import 'dart:convert';
import 'dart:math';
import 'package:covidtracker/newUI.dart';
import 'package:covidtracker/pages/state_stats.dart';
import 'package:covidtracker/size_config/size_config.dart';
import 'package:covidtracker/widget/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class IndiaHome extends StatefulWidget {
  @override
  _IndiaHomeState createState() => _IndiaHomeState();
}

class _IndiaHomeState extends State<IndiaHome>  with SingleTickerProviderStateMixin{
  Map<int, String> monthsInYear = {
    01: "Jan", 02: "Feb", 03: "Mar", 04: "April",
    05: "May", 06: "June",07: "July",08: "Aug",
    09: "Sep", 10: "Oct", 11: "Nov", 12: "Dec",
  };
  AnimationController rotationController;

  List indiaStats;
  Future<dynamic> getIndiaDetails() async{
    String link = "https://api.covid19india.org/data.json";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      indiaStats = data['statewise'];
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
    return Container(
      height: SizeConfig.blockSizeVertical*100,
      child: Stack(
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
                      "India",
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
                        icon: Icon(Icons.refresh, color: isDarkTheme ? Colors.white : Colors.black,),
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
                child: buildIndiaDetails(),
              )
            ],
          ),
          StateStats(),
        ],
      ),
    );
  }



  buildIndiaDetails(){
    return Container(
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            appBar: TabBar(
              labelStyle: TextStyle(
                  fontSize: 15,
                      fontFamily: 'Google-Sans',
                  fontWeight: FontWeight.bold
              ),
              labelColor:isDarkTheme ?  Colors.white : Colors.black,
              unselectedLabelColor: Colors.grey.withOpacity(0.6),
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  text: "Total",
                ),
                Tab(
                  text: "Today",
                ),
                Tab(
                  text: "Yesterday",
                )
              ],
            ),
            body: FutureBuilder(
              future: getIndiaDetails(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(
                      child: CupertinoActivityIndicator()
                  );
                }
                var todayData = indiaStats[0];
                var yesterdayDataList = snapshot.data['cases_time_series'];
                var yesterdayData = yesterdayDataList[yesterdayDataList.length-1];

                int dailyConfirmed = int.parse(todayData['deltaconfirmed']);

                String date = todayData['lastupdatedtime'].split(" ")[0];

                String day = date.split("/")[0];
                String month = date.split("/")[1];

                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    //****************************total**********************
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(255, 178, 89, 1), text: "Total Cases", number: todayData['confirmed']),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CustomCard(color: Color.fromRGBO(237, 96, 94, 1),text: "Death", number: todayData['deaths'])
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(103, 207, 165, 1),text: "Recovered", number: todayData['recovered']),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CustomCard(color: Color.fromRGBO(97, 116, 175, 1), text: "Active", number: todayData['active'])
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CustomCard(color: Color.fromRGBO(144, 89, 255, 1), text: "Update Time", number: todayData['lastupdatedtime'].toString().split(" ")[1])
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    //**************************today*****************************
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(255, 178, 89, 1), text: "Total Cases", number: dailyConfirmed < 0 ? '0' : dailyConfirmed.toString()),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(144, 89, 255, 1), text: "Date", number: day + " " + monthsInYear[int.parse(month)]),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(103, 207, 165, 1),text: "Recovered", number: todayData['deltarecovered']),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CustomCard(color: Color.fromRGBO(237, 96, 94, 1),text: "Death", number: todayData['deltadeaths'])
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //**********************yesterday******************
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(255, 178, 89, 1), text: "Total Cases", number: yesterdayData["dailyconfirmed"]),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(144, 89, 255, 1), text: "Date", number: yesterdayData["date"]),
                                ),
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(color: Color.fromRGBO(103, 207, 165, 1),text: "Recovered", number: yesterdayData["dailyrecovered"]),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CustomCard(color: Color.fromRGBO(237, 96, 94, 1),text: "Death", number: yesterdayData['dailydeceased'])
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
        ),
      ),
    );
  }
}
