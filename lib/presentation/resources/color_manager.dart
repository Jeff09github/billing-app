import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex('#FF5B5B');
  static Color secondary = HexColor.fromHex('#FFFFFF');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = '0xFF' + hexColorString;
    }
    return Color(int.parse(hexColorString));
  }
}
