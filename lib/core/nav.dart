import 'package:flutter/material.dart';

class AppNav extends ChangeNotifier {
  int index = 0;
  void go(int i) {
    index = i;
    notifyListeners();
  }

  static final AppNav instance = AppNav();
}
