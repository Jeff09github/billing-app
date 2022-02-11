import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.kaushanScript(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getRegularStyle(
        {double fontSize = 12.0, Color color = Colors.white}) =>
    _getTextStyle(fontSize, FontWeightManager.regular, color);

TextStyle getBoldStyle({double fontSize = 12.0, Color color = Colors.white}) =>
    _getTextStyle(fontSize, FontWeightManager.bold, color);
