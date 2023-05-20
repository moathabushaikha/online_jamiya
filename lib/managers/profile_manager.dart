import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class ProfileManager extends ChangeNotifier {
  bool get didSelectUser => _didSelectUser;

  bool get darkMode => _darkMode;

  var _didSelectUser = false;
  var _darkMode = false;

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }
  void setUserDarkMode(bool userDarkMode)async
  {
    _darkMode = userDarkMode;
    notifyListeners();
  }

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;
    notifyListeners();
  }
}
