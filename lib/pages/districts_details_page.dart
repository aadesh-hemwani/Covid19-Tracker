import 'dart:convert';
import 'package:covidtracker/models/district.dart';
import 'package:covidtracker/newUI.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DistrictDetails extends StatefulWidget {
  final String state;

  DistrictDetails({this.state});

  @override
  _DistrictDetailsState createState() => _DistrictDetailsState();
}

class _DistrictDetailsState extends State<DistrictDetails> {
  List<District> stateList;
  List<DistrictData> list;

  Future<dynamic> getCases() async{
    var response = await http.get('https://api.covid19india.org/v2/state_district_wise.json',
      headers: {'Accept': 'application/json'},
    );

    if(response.statusCode == 200) {
      List data = json.decode(response.body);
      stateList = data.map<District>((json) => District.fromJson(json)).toList();

      for(int i=0; i<stateList.length; i++){
        if(stateList[i].state == widget.state){
          list = stateList[i].districtData;
        }
      }
      return list;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.state),
      ),
      body: FutureBuilder(
        future: getCases(),
        builder: (context, snap){
          if(!snap.hasData)
            return Center(child: CupertinoActivityIndicator());
          return HorizontalDataTable(
            elevation: 3,
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: 700,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: list.length,
            rowSeparatorWidget: const Divider(
              color: Color.fromRGBO(200, 200, 200, 1),
            ),
            leftHandSideColBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
            rightHandSideColBackgroundColor: isDarkTheme ? Colors.black : Colors.white,

          );
        },
      )
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Districts', 300, isDarkTheme ?  Colors.white : Colors.black,),
      _getTitleItemWidget('Active', 100, Color.fromRGBO(97, 116, 175, 1)),
      _getTitleItemWidget('Recovered', 100, Color.fromRGBO(103, 207, 165, 1)),
      _getTitleItemWidget('Deaths', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Today', 100, Color.fromRGBO(255, 178, 89, 1)),
      _getTitleItemWidget('Deaths Today', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Recovered Today', 100, Color.fromRGBO(103, 207, 165, 1)),
      _getTitleItemWidget('Total', 100, isDarkTheme ?  Colors.white : Colors.black,),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, Color color) {
    return Container(
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      width: width,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          child: Text(list[index].district,),
          width: 200,
          height: 60,
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),

        list[index].notes != '' ?
        Positioned(
            right:0,
            child: Icon(MdiIcons.bell, size: 12, color: Colors.amber,)
        ) : Text(''),
      ],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            list[index].active.toString(),
            style: TextStyle(
                color: Color.fromRGBO(97, 116, 175, 1)
            ),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            list[index].recovered.toString(),
            style: TextStyle(
                color: Color.fromRGBO(103, 207, 165, 1)
            ),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(list[index].deceased.toString(),
            style: TextStyle(
                color: Color.fromRGBO(237, 96, 94, 1)
            ),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(int.parse(list[index].delta.confirmed.toString())>0 ? " +"+list[index].delta.confirmed.toString() : list[index].delta.confirmed.toString() ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),

        Container(
          child: Text(
            list[index].delta.deceased.toString(),
            style: TextStyle(
                color: Color.fromRGBO(237, 96, 94, 1)
            ),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),

        Container(
          child: Text(
            list[index].delta.recovered.toString(),
            style: TextStyle(
                color: Color.fromRGBO(103, 207, 165, 1)
            ),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),

        Container(
          child: Text(
            list[index].confirmed.toString(),
          ),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
      ],
    );
  }
}



