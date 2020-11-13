import 'package:flutter/material.dart';

class _Colors {
  Color main = Color(0xFFFE5239);
  Color background = Color(0xFF22343C);
  Color lightBackground = Color(0xFF30444E);
  Color text = Color(0xFFFFFFFF);
  Color title = Color(0xFF96A7AF);
  Color textPlaceholder = Color(0xFFFFFFFF).withOpacity(0.5);
  Color unSelected = Color(0xFF96A7AF);
  Color divider = Color(0xFFB8C2C0).withOpacity(0.35);
}

class Styles {
  static _Colors colors = _Colors();
  static const double cardRadius = 25.0;
  static const double mainHorizontalPadding = 12.0;
}
