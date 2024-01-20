import 'package:flutter/material.dart';

class MyTheme {
  ThemeData themedata = ThemeData(
    // scaffold background color
    scaffoldBackgroundColor: Colors.black12,
    radioTheme: RadioThemeData(
      // Set the colors for radio buttons
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue;
          }
          return Colors.black;
        },
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.brown[500],
        elevation: 25,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.brown[600]!)),
      ),
    ),
  );
}
