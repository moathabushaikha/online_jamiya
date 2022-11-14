import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'models.dart';

class ProfileManager extends ChangeNotifier {
  SqlService sqlService = SqlService();
  bool get didSelectUser => _didSelectUser;

  bool get darkMode => _darkMode;

  var _didSelectUser = false;
  var _darkMode = false;

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }
  void setUserDarkMode(User user)async
  {
    _darkMode = user.darkMode;
    notifyListeners();
  }

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;
    notifyListeners();
  }
}
