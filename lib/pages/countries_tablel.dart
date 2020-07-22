import 'dart:convert';
import 'package:covidtracker/models/country.dart';
import 'package:covidtracker/newUI.dart';
import 'package:covidtracker/size_config/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {

  List<Country> list;

  Future<dynamic> getGlobalDetails() async{
    String link = "https://coronavirus-19-api.herokuapp.com/countries";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      list = data.map<Country>((json) => Country.fromJson(json)).toList();
      return list;
    }
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 1,
      minChildSize: 0.55,
      builder: (context, controller){
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isDarkTheme ? Colors.black : Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
            ),
            width: double.infinity,
            child: FutureBuilder(
              future: getGlobalDetails(),
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
                          rightHandSideColumnWidth: 1100,
                          isFixedHeader: true,
                          headerWidgets: _getTitleWidget(),
                          leftSideItemBuilder: _generateFirstColumnRow,
                          rightSideItemBuilder: _generateRightHandSideColumnRow,
                          itemCount: snap.data.length-1,
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
      _getTitleItemWidget('Countries', 100, isDarkTheme ?  Colors.white : Colors.black,),
      _getTitleItemWidget('Total Cases', 100, Color.fromRGBO(255, 178, 89, 1)),
      _getTitleItemWidget('Active', 100, Color.fromRGBO(97, 116, 175, 1)),
      _getTitleItemWidget('Recovered', 100, Color.fromRGBO(103, 207, 165, 1)),
      _getTitleItemWidget('Deaths', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Critical', 100, Color.fromRGBO(144, 89, 255, 1)),
      _getTitleItemWidget('Today', 100,  isDarkTheme ?  Colors.white : Colors.black,),
      _getTitleItemWidget('Deaths Today', 100, Color.fromRGBO(237, 96, 94, 1)),
      _getTitleItemWidget('Tests', 100,  isDarkTheme ?  Colors.white : Colors.black ),
      _getTitleItemWidget('Cases/1M', 100,  isDarkTheme ?  Colors.white : Colors.black ),
      _getTitleItemWidget('Deaths/1M', 100,  isDarkTheme ?  Colors.white : Colors.black ),
      _getTitleItemWidget('Tests/1M', 100,  isDarkTheme ?  Colors.white : Colors.black ),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, Color color) {
    return Container(
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      width: width,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: label == "Countries" ? Alignment.centerLeft : Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    index++;
    return Row(
      children: [
        Container(
          child: Text(index.toString() + "." ),
          height: 70,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: 70,
          ),
          child: Text(list[index].country),
          height: 70,

          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    index++;
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            list[index].cases.toString(),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            list[index].active.toString(),
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
            list[index].recovered.toString(),
            style: TextStyle(
                color: Color.fromRGBO(103, 207, 165, 1)
            ),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(list[index].deaths.toString(),
            style: TextStyle(
                color: Color.fromRGBO(237, 96, 94, 1)
            ),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(list[index].critical.toString(),
            style: TextStyle(
                color: Color.fromRGBO(144, 89, 255, 1)
            ),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(list[index].todayCases>0 ? " +"+list[index].todayCases.toString() : list[index].todayCases.toString() ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),

        Container(
          child: Text(
            list[index].todayDeaths.toString(),
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
            list[index].totalTests.toString(),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            list[index].casesPerOneMillion.toString(),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            list[index].deathsPerOneMillion.toString(),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            list[index].testsPerOneMillion.toString(),
          ),
          width: 100,
          height: 70,
          alignment: Alignment.center,
        ),

      ],
    );
  }
}
