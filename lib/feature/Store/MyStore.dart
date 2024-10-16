import 'package:flutter/material.dart';

class MyStore extends ChangeNotifier {
  var isDarkMode = true;

  changeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}