import 'dart:convert';

MyNotification notificationFromJson(String str) =>
    MyNotification.fromMap(json.decode(str));

String notificationToJson(MyNotification data) =>
    json.encode(data.toMapWithId());

class MyNotification {
  String id;
  String jamiyaId;
  String userToNoti;
  String userFromNoti;
  String notificationDate;
  String notificationType;

  MyNotification(
    this.id,
    this.jamiyaId,
    this.userToNoti,
    this.userFromNoti,
    this.notificationDate,
    this.notificationType,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'jamiyaId': jamiyaId,
      'userToNoti': userToNoti,
      'userFromNoti': userFromNoti,
      'notificationDate': notificationDate,
      'notificationType': notificationType,
    };
    return map;
  }

  Map<String, dynamic> toMapWithId() {
    final map = <String, dynamic>{
      'ID': id,
      'CREATOR_ID': userToNoti,
      'JAMIYA_ID': jamiyaId,
      'PARTICIPANT_ID': userFromNoti,
      'REQUEST_DATE': notificationDate,
      'NOTIFICATION_TYPE': notificationType,
    };
    return map;
  }

  factory MyNotification.fromMap(Map<String, dynamic> map) {
    return MyNotification(
      map['_id'].toString(),
      map['jamiyaId'],
      map['userToNoti'],
      map['userFromNoti'],
      map['notificationDate'],
      map['notificationType'],
    );
  }
}
