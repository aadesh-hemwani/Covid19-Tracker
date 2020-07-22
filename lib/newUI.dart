import 'package:covidtracker/pages/global_db.dart';
import 'package:covidtracker/pages/indiaHome.dart';
import 'package:covidtracker/pages/settings.dart';
import 'package:covidtracker/size_config/size_config.dart';
import 'package:covidtracker/theme/constants.dart';
import 'package:covidtracker/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isDarkTheme;
class NewHome extends StatefulWidget {
  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  int currentScreen = 0;
  SharedPreferences prefs;
  ThemeNotifier themeNotifier;
  PageController pageController;

  void initState(){
    pageController = PageController();
    super.initState();
  }

  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentScreen = index;
      pageController.animateToPage(currentScreen, duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentScreen = value;
              });
            },
            children: [
              IndiaHome(),
              Global(),
              SettingScreen(),
            ],
          ),
          Positioned(
            bottom: 0,right: 0,left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 10,
                    spreadRadius: 2
                  )
                ]
              ),
              child: buildBNB(),
            )
          )
        ],
      ),
    );
  }


  buildBNB(){
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: BottomNavigationBar(
        currentIndex: currentScreen,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.homeHeart ),
              title: currentScreen == 0 ? Icon(MdiIcons.circleMedium, size: 15) : Text("")
          ),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.earth,),
              title: currentScreen == 1 ? Icon(MdiIcons.circleMedium, size: 15) : Text("")
          ),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.cog),
              title: currentScreen == 2 ? Icon(MdiIcons.circleMedium, size: 15) : Text("")
          ),

        ],
      ),
    );
  }

  void onThemeChanged(String value) async {
    var prefs = await SharedPreferences.getInstance();
    if (value == Constants.SYSTEM_DEFAULT) {
      themeNotifier.setThemeMode(ThemeMode.system);
    } else if (value == Constants.DARK) {
      themeNotifier.setThemeMode(ThemeMode.dark);
    } else {
      themeNotifier.setThemeMode(ThemeMode.light);
    }
    prefs.setString(Constants.APP_THEME, value);
  }
}
