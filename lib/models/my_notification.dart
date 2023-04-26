import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MyNotification notificationFromJson(String str) => MyNotification.fromMap(json.decode(str));

String notificationToJson(MyNotification data) => json.encode(data.toMapWithId());

class MyNotification {
  String id;
  String jamiyaId;
  String notificationCreatorId;
  String notificationReceiverId;
  String notificationDate;
  String notificationType;

  MyNotification(
      {required this.id,
      required this.jamiyaId,
      required this.notificationCreatorId,
      required this.notificationReceiverId,
      required this.notificationDate,
      required this.notificationType});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'jamiyaId': jamiyaId,
      'notification_creator_id': notificationCreatorId,
      'notification_receiver_id': notificationReceiverId,
      'notificationDate': notificationDate,
      'notificationType': notificationType,
    };
    return map;
  }

  Map<String, dynamic> toMapWithId() {
    final map = <String, dynamic>{
      'ID': id,
      'CREATOR_ID': notificationCreatorId,
      'JAMIYA_ID': jamiyaId,
      'PARTICIPANT_ID': notificationReceiverId,
      'REQUEST_DATE': notificationDate,
      'NOTIFICATION_TYPE': notificationType,
    };
    return map;
  }

  factory MyNotification.fromMap(Map<String, Object?>? map) {
    if (map != null) {
      ObjectId obid = map['_id'] as ObjectId;
      return MyNotification(
        id: obid.$oid,
        jamiyaId: map['jamiyaId'].toString(),
        notificationCreatorId: map['notification_creator_id'].toString(),
        notificationReceiverId: map['notification_receiver_id'].toString(),
        notificationDate: map['notificationDate'].toString(),
        notificationType: map['notificationType'].toString(),
      );
    } else {
      return MyNotification(
          id: '0',
          jamiyaId: '0',
          notificationCreatorId: '0',
          notificationReceiverId: '0',
          notificationDate: '0',
          notificationType: '0');
    }
  }
}
