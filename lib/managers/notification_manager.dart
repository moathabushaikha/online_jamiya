import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'managers.dart';
import 'package:online_jamiya/models/models.dart';

class NotificationManager extends ChangeNotifier {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  List<MyNotification>? _notifications;

  List<MyNotification> get notifications {
    if (_notifications != null) {
      return List.unmodifiable(_notifications!);
    } else {
      return [];
    }
  }

  MyNotification? notificationItemById(String id) {
    final index = _notifications?.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return _notifications![index!];
  }

  void addNotification(MyNotification notification) async {
    var mongoResult = await apiMongoDb.createNotification(notification);
    if (mongoResult != null) {
      MyNotification mongodbNotification = mongoResult;
      _notifications?.add(mongodbNotification);
      notifyListeners();
    }
  }

  Future<List<MyNotification>?> getAllNotification() async {
    _notifications = await apiMongoDb.getAllNotifications();
    return _notifications;
  }

  void deleteNotification(MyNotification? myNotification) async {
    _notifications?.removeWhere((element) => element == myNotification);
    if (myNotification != null) {
      await apiMongoDb.deleteNotification(myNotification);
    }
    notifyListeners();
  }
}
