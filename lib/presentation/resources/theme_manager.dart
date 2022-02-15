import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/font_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primaryColor: ColorManager.primary,

    //Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorManager.primary,
        backgroundColor: ColorManager.secondary,
        textStyle: getBoldStyle(color: ColorManager.primary),
      ),
    ),
    //Text Theme
    textTheme: TextTheme(
      headline1: getBoldStyle(
          fontSize: FontSizeManager.splashFontSize,
          color: ColorManager.secondary),
      bodyText1: getRegularStyle(
          fontSize: FontSizeManager.s14, color: ColorManager.secondary),
    ),
  );
}
