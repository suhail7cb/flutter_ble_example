import 'package:flutter/material.dart';


ThemeData appDarkTheme() {
  final  ThemeData darkTheme = ThemeData.dark();

  return darkTheme.copyWith(
      primaryColor: Colors.black38,
      buttonTheme: darkTheme.buttonTheme.copyWith(
          buttonColor: Color(0xFF23AFF6),
          disabledColor: Color(0xFFB6E4FC)
      ),
    ///Add value to other properties
  );
}

