import 'package:flutter/material.dart';

class AppColors extends ChangeNotifier {
  AppColors({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? textColor,
  })  : backgroundColor = backgroundColor ?? const Color(0xFFFFF9EB),
        foregroundColor = foregroundColor ?? Colors.white,
        textColor = textColor ?? const Color(0xFF8B6B1A);

  Color backgroundColor;
  Color foregroundColor;
  Color textColor;

  void setBackgroundColor(Color color) {
    if (backgroundColor == color) return;
    backgroundColor = color;
    notifyListeners();
  }

  void setForegroundColor(Color color) {
    if (foregroundColor == color) return;
    foregroundColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    if (textColor == color) return;
    textColor = color;
    notifyListeners();
  }
}
