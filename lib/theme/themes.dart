import 'package:flutter/material.dart';

class AppTheme {
  get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color.fromRGBO(31, 31, 31, 1),
    fontFamily: 'Google-Sans'
  );

  get lightTheme => ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Color.fromRGBO(237, 247, 255, 1),
      fontFamily: 'Google-Sans'
  );
}
