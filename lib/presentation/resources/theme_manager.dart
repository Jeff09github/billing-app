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
        headline2: getBoldStyle(
            fontSize: FontSizeManager.splashFontSize,
            color: ColorManager.secondary),
        headline3: getBoldStyle(
            fontSize: FontSizeManager.s14,
            color: ColorManager.secondary),
        bodyText1: getRegularStyle(
            fontSize: FontSizeManager.s14, color: ColorManager.secondary),
        bodyText2: getRegularStyle(
            fontSize: FontSizeManager.s16, color: ColorManager.secondary),
        subtitle1: getRegularStyle(
            fontSize: FontSizeManager.s14, color: ColorManager.primary),
      ),
      //Appbar Theme
      appBarTheme: AppBarTheme(
        color: ColorManager.primary,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 35.0,
        ),
        // actionsIconTheme: const IconThemeData(
        //   color: Colors.white,
        //   size: 60.0,
        // ),
      ),
      dividerColor: ColorManager.secondary);
}
