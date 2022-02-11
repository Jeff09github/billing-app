import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/font_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    //Text Theme
    textTheme: TextTheme(
      headline1: getBoldStyle(fontSize: FontSizeManager.s16),
      bodyText1: getRegularStyle(fontSize: FontSizeManager.s14),
    ),
  );
}
