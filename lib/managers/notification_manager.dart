import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'managers.dart';
import 'package:online_jamiya/models/models.dart';

class NotificationManager extends ChangeNotifier {
  final AppCache _appCache = AppCache();
  final SqlService sqlService = SqlService();
  final ApiService apiService = ApiService();
  List<MyNotification>? _notifications;

  List<MyNotification> get notifications {
    if (_notifications != null) {
      return List.unmodifiable(_notifications!);
    } else {
      return [];
    }
  }

  Future<void> setNotifications(List<MyNotification> notificationsList) async {
    _notifications = notificationsList;
    _appCache.setNotificationsList(notificationsList);
  }

  MyNotification? notificationItemById(String id) {
    final index = _notifications?.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return _notifications![index!];
  }

  void addNotification(MyNotification notification) async {
    // int newNotificationId = await sqlService.createNotification(notification);
    // MyNotification newNotification =
    //    await sqlService.readSingleNotification(newNotificationId.toString());
    MyNotification newNotification =  await apiService.createNotification(notification);
    _notifications?.add(newNotification);
    if (_notifications != null) {
      _appCache.setNotificationsList(_notifications!);
      notifyListeners();
    }
  }
  Future <List<MyNotification>?> getAllNotification() async{
    _notifications = await apiService.getAllNotifications();
    return _notifications;
  }
  void deleteNotification(MyNotification? myNotification) async {
    _notifications?.removeWhere((element) => element == myNotification);
    if (myNotification != null) {
      await apiService.deleteNotification(myNotification);
    }
    await _appCache.setNotificationsList(_notifications!);
    notifyListeners();
  }
}
