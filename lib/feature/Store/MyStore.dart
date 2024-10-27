import 'package:flutter/cupertino.dart';

class MyStore extends ChangeNotifier {
  var isDarkMode = false;
  var onAlarm = true;

  changeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  changeAlarm() {
    onAlarm = !onAlarm;
    notifyListeners();
  }
}