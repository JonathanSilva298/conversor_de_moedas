import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  static ThemeController instance = ThemeController();

  bool isDarkTheme = false;

  IconData icon = Icons.brightness_6;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    icon = isDarkTheme ? Icons.brightness_6_outlined : Icons.brightness_6;

    notifyListeners();
  }
}
