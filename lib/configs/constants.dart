import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2196F3);
const Color accentColor = Color(0xFFFF4081);
const Color appWhiteColor = Color(0xFFFFFFFF);
const Color appBlackColor = Color(0xFF000000);
const Color appGrayColor = Color(0xFF404040);
const Color successColor = Color(0xFF4CAF50);
const Color errorColor = Color(0xFFFF1744);
const Color darkBackgroundColor = Color(0xFF121212);

class AppTheme {
  final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: appWhiteColor,
    indicatorColor: successColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(color: appWhiteColor),
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: appGrayColor),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: appWhiteColor,
      onPrimary: appBlackColor,
      onSecondary: appBlackColor,
      onSurface: appBlackColor,
      onError: appWhiteColor,
      brightness: Brightness.light,
    ),
  );

  final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    indicatorColor: successColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      titleTextStyle: TextStyle(color: appWhiteColor),
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: appWhiteColor),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: darkBackgroundColor,
      onPrimary: appWhiteColor,
      onSecondary: appWhiteColor,
      onSurface: appWhiteColor,
      onError: appBlackColor,
      brightness: Brightness.dark,
    ),
  );
}
