import 'package:flutter/material.dart';

part 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Colors.green,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: backgroundColor,
        disabledColor: Colors.grey,
        selectedColor: Colors.green,
        secondarySelectedColor: Colors.green,
        padding: EdgeInsets.all(8),
        shape: StadiumBorder(),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        secondaryLabelStyle: TextStyle(
          color: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
    );
  }
}
