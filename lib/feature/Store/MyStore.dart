import 'package:flutter/cupertino.dart';

class MyStore extends ChangeNotifier {
  var isDarkMode = false;
  var onAlarm = true;
  var isReversed = false;

  changeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  changeAlarm() {
    onAlarm = !onAlarm;
    notifyListeners();
  }

  changeReversed() {
    isReversed = !isReversed;
    notifyListeners();
  }
}