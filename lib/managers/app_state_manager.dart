import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/api/api_mongoDb.dart';
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
  ApiMongoDb apiMongoDb = ApiMongoDb();
  bool _loggedIn = false;
  int _selectedTab = JamiyaTabs.mainScreen;

  bool get isLoggedIn => _loggedIn;

  int get getSelectedTab => _selectedTab;

  Future<void> initializeApp() async {
    //Check if the user is logged in
    _loggedIn = await _appCache.isUserLoggedIn();
  }

  void register(User newUser, BuildContext context) async {
    bool userAdded = await apiMongoDb.createUser(newUser);
    String registrationMsg = '';
    if (userAdded) {
      registrationMsg = "go to login";
      notifyListeners();
    } else {
      registrationMsg = "user already exists";
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Completed'),
          content: const SingleChildScrollView(
            child: Text('Your Registration is completed please go to login page !'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(registrationMsg),
              onPressed: () {
                context.goNamed('login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> login(String username, String password) async {
    int loginResult = await apiMongoDb.signInUser(username, password);
    if (loginResult == 0)
      {
        _loggedIn = true;
        notifyListeners();
        return loginResult;
      }
      return loginResult;
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await apiMongoDb.updateUser(user);
    notifyListeners();
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
