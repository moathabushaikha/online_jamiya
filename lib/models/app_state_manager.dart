import 'dart:async';
import 'package:flutter/material.dart';
import 'models.dart';
import 'package:online_jamiya/api/api.dart';

class JamiyaTabs {
  static const int mainScreen = 0;
  static const int explore = 1;
}

class AppStateManager extends ChangeNotifier {

  final _appCache = AppCache();
  final SqlService sqlService = SqlService();
  User? _currentUser;
  bool _loggedIn = false;
  int _selectedTab = JamiyaTabs.mainScreen;

  bool get isLoggedIn => _loggedIn;
  int get getSelectedTab => _selectedTab;
  User? get currentUser => _currentUser;


  Future<void> initializeApp() async {
    //Check if the user is logged in
    _loggedIn = await _appCache.isUserLoggedIn();
  }
  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }
  void register(User registeredUser) async {
    int id = await SqlService().createUser(registeredUser);
    User? userFromDb = await SqlService().readSingleUser(id);
     _appCache.setCurrentUser(userFromDb);
    _loggedIn = true;
    notifyListeners();
  }

  void login(String username, String password) async {
      _currentUser = await DataBaseConn.instance.authentication(username, password);
    if (_currentUser != null) {
      _appCache.setCurrentUser(_currentUser!);
      _loggedIn = true;
      await _appCache.cacheUser();
      notifyListeners();
    }
  }
  void logout() async {
    // Reset all properties once user logs out
    _loggedIn = false;
    _selectedTab = 0;
    // Reinitialize the app
    await _appCache.invalidate();
    await initializeApp();
    notifyListeners();
  }

}