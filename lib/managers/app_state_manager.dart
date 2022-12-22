import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/api/api.dart';
import 'managers.dart';

class JamiyaTabs {
  static const int mainScreen = 0;
  static const int explore = 1;
}

class AppStateManager extends ChangeNotifier {
  final _appCache = AppCache();
  ApiService apiService = ApiService();
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

  Future<void> updateUser(User user) async {
    await sqlService.updateUser(user);
    _appCache.setCurrentUser(user);
    notifyListeners();
  }

  void register(User registeredUser) async {
    // int id = await sqlService.createUser(registeredUser);
    // User? userFromDb = await sqlService.readSingleUser(id);
    await apiService.createUser(registeredUser);
    //await _appCache.setCurrentUser(userFromDb);
    _loggedIn = true;
    notifyListeners();
  }

  void login(String username, String password,BuildContext context) async {
    _currentUser =
        await DataBaseConn.instance.authentication(username, password);
    if (_currentUser != null) {
      Provider.of<ProfileManager>(context, listen: false)
          .setUserDarkMode(_currentUser!);
      _appCache.setCurrentUser(_currentUser!);
      _loggedIn = true;
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
