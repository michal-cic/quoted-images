import 'package:flutter/material.dart';

class ColorUtility {

  static Color hexConvert(String color) {
    var hexColor = color.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "DF" + hexColor;
    }

    Color retColor = Color(int.parse(hexColor, radix: 16));
    return retColor.withOpacity(1);
  }

  static Color getNegativeColor(Color backgroundColor) {
    Color foregroundColor = Colors.black38;

    if (backgroundColor.computeLuminance() < 0.5) {
      foregroundColor = Colors.white38;
    }

    return foregroundColor;
  }
}
