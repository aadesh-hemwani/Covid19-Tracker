import 'dart:convert';
import 'package:covidtracker/models/state.dart';
import 'package:covidtracker/newUI.dart';
import 'package:covidtracker/pages/districts_details_page.dart';
import 'package:covidtracker/size_config/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StateStats extends StatefulWidget {
  @override
  _StateStatsState createState() => _StateStatsState();
}

class _StateStatsState extends State<StateStats> {
  List<StateModel> list;
  Future<dynamic> getStatesDetails() async{
    String link = "https://api.covid19india.org/data.json";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var rest = data['statewise'] as List;
      list = rest.map<StateModel>((json)=> StateModel.fromJson(json)).toList();
    }

    return list;
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 1,
      minChildSize: 0.5,
      builder: (context, controller){
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isDarkTheme ? Colors.black : Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
            ),
            width: double.infinity,
            child: FutureBuilder(
              future: getStatesDetails(),
              builder: (context, snap){
                if(!snap.hasData)
                  return Text("");
                return SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Icon(Icons.keyboard_arrow_up),
                      Container(
                        height: SizeConfig.blockSizeVertical*98,
                        child: HorizontalDataTable(
                          elevation: 2,
                          leftHandSideColumnWidth: 100,
                          rightHandSideColumnWidth: 700,
                          isFixedHeader: true,
                          headerWidgets: _getTitleWidget(),
                          leftSideItemBuilder: _generateFirstColumnRow,
                          rightSideItemBuilder: _generateRightHandSideColumnRow,
                          itemCount: 37,
                          rowSeparatorWidget: const Divider(
                            color: Color.fromRGBO(200, 200, 200, 1),
                          ),
                          leftHandSideColBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
                          rightHandSideColBackgroundColor: isDarkTheme ? Colors.black : Colors.white,

                        ),
                      ),
                    ],
                  ),
                );
              },
            )
        );
      },
    );
  }
  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('States', 300, isDarkTheme ?  Colors.white : Colors.black,),
      _getTitleItemWidget('Active', 100, Color.fromRGBO(97, 116, 175, 1)),
      _getTitleItemWidget('Recovered', 100, Color.fromRGBO(103, 207, 165, 1)),
      _getTitleItemWidget('Deaths', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Today', 100, Color.fromRGBO(255, 178, 89, 1)),
      _getTitleItemWidget('Deaths Today', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Recovered Today', 100, Color.fromRGBO(103, 207, 165, 1)),
      _getTitleItemWidget('Total Cases', 100, isDarkTheme ?  Colors.white : Colors.black,),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, Color color) {
    return Container(
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      width: width,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: label == "States" ? Alignment.centerLeft : Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    index++;
    return InkWell(
      onTap: list[index].statenotes != '' ?  () {
        showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                  opacity: a1.value,
                  child: SimpleDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: isDarkTheme ? Color.fromRGBO(41, 41, 41, 1) : Color.fromRGBO(241, 245, 255, 1),
                    elevation: 0,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                            list[index].state,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(list[index].statenotes),
                      ),
                    ],
                  )
              ),

            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          context: context,
          barrierLabel: '',
          // ignore: missing_return
          pageBuilder: (context, animation1, animation2){},
        );
      } : (){},
      child: Stack(
        children: [
          Container(
            child: Text(list[index].state),
            width: 200,
            height: 70,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),

          list[index].statenotes != '' ?
          Positioned(
              right:0,
              child: Icon(MdiIcons.bell, size: 12, color: Colors.amber,)
          ) : Text(''),
        ],
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    index++;
    return InkWell(
      onTap: (){
        Navigator.push(context,
            CupertinoPageRoute(
              builder: (_) => DistrictDetails(state: list[index].state,)
            )
        );
      },
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              list[index].active,
              style: TextStyle(
                  color: Color.fromRGBO(97, 116, 175, 1)
              ),
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),
          Container(
            child: Text(
              list[index].recovered,
              style: TextStyle(
                  color: Color.fromRGBO(103, 207, 165, 1)
              ),
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),
          Container(
            child: Text(list[index].deaths,
              style: TextStyle(
                  color: Color.fromRGBO(237, 96, 94, 1)
              ),
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),
          Container(
            child: Text(int.parse(list[index].deltaconfirmed)>0 ? " +"+list[index].deltaconfirmed : list[index].deltaconfirmed ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),

          Container(
            child: Text(
              list[index].deltadeaths,
              style: TextStyle(
                  color: Color.fromRGBO(237, 96, 94, 1)
              ),
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),

          Container(
            child: Text(
              list[index].deltarecovered,
              style: TextStyle(
                  color: Color.fromRGBO(103, 207, 165, 1)
              ),
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),
          Container(
            child: Text(
              list[index].confirmed,
            ),
            width: 100,
            height: 70,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
