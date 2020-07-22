import 'dart:convert';
import 'dart:math';
import 'package:covidtracker/newUI.dart';
import 'package:covidtracker/pages/countries_tablel.dart';
import 'package:covidtracker/size_config/size_config.dart';
import 'package:covidtracker/widget/custom_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Global extends StatefulWidget {
  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> with  SingleTickerProviderStateMixin {
  AnimationController rotationController;

  Future<dynamic> getGlobalDetails() async{
    String link = "https://coronavirus-19-api.herokuapp.com/countries";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      return data;
    }
  }

  @override
  void initState() {
    rotationController = AnimationController(duration: Duration(milliseconds: 2200),vsync: this, upperBound: pi*0.71);
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical*4.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Global",
                    style: TextStyle(
                        fontSize: 40
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: IconButton(
                      icon: Icon(Icons.refresh, color: isDarkTheme ? Colors.white : Colors.black, ),
                      iconSize: SizeConfig.blockSizeVertical*3.5,
                      color: Colors.white,
                      onPressed: ()async{
                        rotationController.repeat();
                        setState(() {
                        });
                        await Future.delayed(Duration(milliseconds: 2000));
                        rotationController.reset();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: getTotalStats(),
            )
          ],
        ),
        Countries(),
      ],
    );
  }

  getTotalStats(){
    return Container(
      child:FutureBuilder(
            future: getGlobalDetails(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomCard(color: Color.fromRGBO(255, 178, 89, 1), text: "Total Cases", number: snapshot.data[0]["cases"].toString()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomCard(color: Color.fromRGBO(144, 89, 255, 1), text: "Critical", number: snapshot.data[0]['critical'].toString())
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomCard(color: Color.fromRGBO(103, 207, 165, 1),text: "Recovered", number: snapshot.data[0]["recovered"].toString()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomCard(color: Color.fromRGBO(237, 96, 94, 1),text: "Death", number: snapshot.data[0]["deaths"].toString())
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
      )
    );
  }
}

