import 'package:flutter/material.dart';
import 'palette.dart';

class AppTheme {

  const AppTheme();

  static final ThemeData light = ThemeData(
      accentColor: Palette.accentColor,
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      backgroundColor: Colors.white,
      buttonColor: Palette.accentColor,
      appBarTheme: AppBarTheme(
        elevation: 50.0,
        color: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme:
            TextTheme(title: TextStyle(fontSize: 20.0, color: Colors.white)),
      ),
      colorScheme: ColorScheme(
          primary: Palette.primaryColor,
          primaryVariant: Palette.primaryColor,
          secondary: Palette.secondaryColor,
          secondaryVariant: Palette.secondaryVariant,
          surface: Palette.background,
          background: Palette.background,
          error: Colors.red,
          onPrimary: Palette.darker,
          onSecondary: Palette.background,
          onSurface: Palette.darker,
          onBackground: Palette.titleTextColor,
          onError: Palette.titleTextColor,
          brightness: Brightness.dark),
      fontFamily: 'Manrope',
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)));

  static TextStyle titleStyle = TextStyle(color: Palette.lightblack, fontSize: 16);

  static TextStyle subTitleStyle = TextStyle(color: Palette.subTitleTextColor, fontSize: 12);

  static TextStyle h1Style = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style =
      TextStyle(fontSize: 22);
  static TextStyle h3Style =
      TextStyle(fontSize: 20);
  static TextStyle h4Style =
      TextStyle(fontSize: 18);
  static TextStyle h5Style =
      TextStyle(fontSize: 16);
  static TextStyle h6Style =
      TextStyle(fontSize: 14);
}