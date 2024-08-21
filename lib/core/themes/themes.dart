import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0aad9f);
const Color darkColor = Color(0xFF27302C);
const Color lightColor = Color(0xFFF2F2F2);

enum MyThemes {
  light("Light"),
  dark("Dark");

  const MyThemes(this.name);
  final String? name;
}

final myThemeData = {
  // light theme

  MyThemes.light: ThemeData(
    //theme of button
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(300)),
      backgroundColor: primaryColor,
    )),

    primaryColor: primaryColor,

    //theme of text
    textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: "jozoor"),
        displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "jozoor"),
        displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            fontFamily: "jozoor")),

    //theme of appbar
    appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    //theme of icon
    iconTheme: const IconThemeData(color: primaryColor),

    //theme of field
    inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: lightColor,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: lightColor),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkColor),
            borderRadius: BorderRadius.all(Radius.circular(12)))),
  ),

  // dark theme

  MyThemes.dark: ThemeData(
    //theme of button
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(300)),
      backgroundColor: primaryColor,
    )),

    primaryColor: primaryColor,

    //theme of text
    textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: "jozoor"),
        displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "jozoor"),
        displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            fontFamily: "jozoor")),

    //theme of appbar
    appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,

    //theme of icon
    iconTheme: const IconThemeData(color: primaryColor),

    //theme of field
    inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: darkColor,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkColor),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: lightColor),
            borderRadius: BorderRadius.all(Radius.circular(12)))),
  ),
};
