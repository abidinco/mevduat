import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const colorPalette = {
  "lightPrimary": Color(0xFF800000),
  "darkPrimary": Color(0xFF800000),
  "darkest": Color(0xFF1A1A1A),
  "darker": Color(0xFFDCDCB),
  "dark": Color(0xFF626262),
  "light": Color(0xFF878787),
  "lighter": Color(0xFFC4C4c3),
};

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: colorPalette['darkPrimary'],
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        // alert title
        headline6: TextStyle(color: colorPalette['darkPrimary']),
        // tile leading
        bodyText2: TextStyle(color: colorPalette['darkPrimary']),
        // tile title + alert text
        subtitle1: TextStyle(color: colorPalette['darkest']),
        // tile subtitle
        caption: TextStyle(color: colorPalette['dark']),
        button: TextStyle(fontFamily: "Bevan"),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
          )
      )
  );
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      primaryColor: colorPalette['lightPrimary'],
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        // alert title
        headline6: TextStyle(color: colorPalette['light']),
        // tile leading
        bodyText2: TextStyle(color: colorPalette['darker']),
        // tile title, article title
        subtitle1: TextStyle(color: Colors.white70),
        // tile subtitle, article subtitle
        caption: TextStyle(color: Colors.white38),
        button: TextStyle(fontFamily: "Bevan"),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
          )
      )
  );
}