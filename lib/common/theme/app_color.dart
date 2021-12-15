import 'dart:math';

import 'package:flutter/widgets.dart';

class AppColor {
  static const black = Color(0xFF232832);
  static const dark = Color(0xFF515761);
  static const white = Color(0xFFFFFFFF);
  static const light = Color(0xFFF0F1F4);
  static const gray = Color(0xFFABB1BA);

  //  General Color
  static const red = Color(0xFFEB4747);
  static const orange = Color(0xFFC56E16);
  static const yellow = Color(0xFFC5C516);
  static const green = Color(0xFF16C56E);
  static const teal = Color(0xFF16C5B7);

  static Color getColor({int index = 5}) {
    final List<Color> colors = [red, orange, yellow, green, teal, gray];

    return colors[index];
  }

  static Color randomColor() {
    final List<Color> colors = [red, orange, yellow, green, teal, light];

    return colors[Random().nextInt(colors.length)];
  }
}
