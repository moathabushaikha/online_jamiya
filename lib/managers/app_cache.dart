import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_jamiya/models/models.dart';

class AppCache extends ChangeNotifier{
  static const kUser = 'user';
  static const currentUser = 'currentUser';
  static const allJamiyas = 'jamiyaItems';
  static const allNotifications = 'notifications';
  static const darkMode = 'darkMode';
  List<String> allJamiyaJsonList = [];
  User? loggedInUser;

  Future<void> setCurrentUser(User cUser) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(currentUser, jsonEncode(cUser));
  }
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? loggedInUserJson = prefs.getString(currentUser);
    loggedInUser = userFromJsonSharedPrefs(loggedInUserJson!);
    print('luDM ${loggedInUser?.darkMode}');
    return loggedInUser;
  }
  Future<void> setToken(String resBody)async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", jsonDecode(resBody)['token']);
  }

  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, false);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kUser) ?? false;
  }
}
