import 'package:flutter/material.dart';

class MyStore extends ChangeNotifier {
  var isDarkMode = false;

  changeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}