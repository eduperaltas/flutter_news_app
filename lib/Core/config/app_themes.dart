import 'package:flutter/material.dart';

//theme to be used in the app dark and light

abstract class Apptheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.black38,
      accentColor: Colors.black38,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black38,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black38,
        textTheme: ButtonTextTheme.primary,
      ),
      splashColor: Colors.transparent,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.black,
      brightness: Brightness.dark,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
        textTheme: ButtonTextTheme.primary,
      ),
      splashColor: Colors.transparent,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    );
  }
}
