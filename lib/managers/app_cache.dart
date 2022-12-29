import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_jamiya/models/models.dart';

class AppCache {
  static const kUser = 'user';
  static const currentUser = 'currentUser';
  static const allJamiyas = 'jamiyaItems';
  static const allNotifications = 'notifications';
  static const darkMode = 'darkMode';
  List<String> allJamiyaJsonList = [];
  User? loggedInUser;

  Future<void> setCurrentUser(User user) async {
    String currentUserStr = userToMap(user);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(currentUser, currentUserStr);
  }
  Future<void> setToken(String resBody)async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", jsonDecode(resBody)['token']);
  }
  Future<void> setJamiyat(List<Jamiya>? allJamiyat) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jamiyaItemsList = [];
    for (var element in allJamiyat!) {
      var stringElement = jamiyaToMap(element);
      jamiyaItemsList.add(stringElement);
    }
    prefs.setStringList(allJamiyas, jamiyaItemsList);
  }

  Future<List<Jamiya>> allJamiyat() async {
    final prefs = await SharedPreferences.getInstance();
    var x = prefs.getStringList(allJamiyas);
    List<Jamiya> jamiyat = [];
    if (x != null) {
      for (var element in x) {
        jamiyat.add(jamiyaFromJson(element));
      }
    }
    return jamiyat;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? loggedInUserJson = prefs.getString(currentUser);
    loggedInUser = userFromJson(loggedInUserJson!);
    return loggedInUser;
  }
  Future<void> setNotificationsList(List<MyNotification> myNotifications)async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notificationToString = myNotifications.map((e) => notificationToJson(e)).toList();
    prefs.setStringList(allNotifications,notificationToString);
  }
  Future<List<MyNotification>> getNotificationsList()async
  {
    final prefs = await SharedPreferences.getInstance();
    var notificationsListOfString = prefs.getStringList(allNotifications);
    return notificationsListOfString!.map((e) => notificationFromJson(e)).toList();
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
