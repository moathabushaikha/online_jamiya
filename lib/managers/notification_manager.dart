import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'managers.dart';
import 'package:online_jamiya/models/models.dart';

class NotificationManager extends ChangeNotifier {
  final AppCache _appCache = AppCache();
  final SqlService sqlService = SqlService();
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
    List<MyNotification> allNotifications = await sqlService.allNotifications();
    if (notificationNotExist(notification, allNotifications)) {
      int newNotificationId = await sqlService.createNotification(notification);
      MyNotification newNotification =
          await sqlService.readSingleNotification(newNotificationId.toString());
      _notifications?.add(newNotification);
      if (_notifications != null) {
        _appCache.setNotificationsList(_notifications!);
      }
      notifyListeners();
    }
  }

  void deleteNotification(MyNotification? myNotification) async {
    _notifications?.removeWhere((element) => element == myNotification);
    if (myNotification != null) {
      await sqlService.deleteNotification(myNotification.id);
    }
    await _appCache.setNotificationsList(_notifications!);
    notifyListeners();
  }

  Future<void> updateItem(MyNotification myNotification, index) async {
    await sqlService.updateNotification(myNotification);
    MyNotification updatedNotification =
        await sqlService.readSingleNotification(myNotification.id);
    _notifications![index] = updatedNotification;
    notifyListeners();
  }

  bool notificationNotExist(
      MyNotification notification, List<MyNotification> allNotifications) {
    for (int i = 0; i < allNotifications.length; i++) {
      if (allNotifications[i].jamiyaId == notification.jamiyaId) {
        if (allNotifications[i].userToEnrollId == notification.userToEnrollId) {
          return false;
        }
      }
    }
    return true;
  }
}
