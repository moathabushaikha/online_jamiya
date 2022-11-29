import 'dart:convert';


MyNotification notificationFromJson(String str) => MyNotification.fromMap(json.decode(str));
String notificationToJson(MyNotification data) => json.encode(data.toMapWithId());

class MyNotification {
  String id;
  String jamiyaId;
  String creatorId;
  String userToEnrollId;
  String notificationDate;
  String response;
  String notificationType;

  MyNotification(
    this.id,
    this.jamiyaId,
    this.creatorId,
    this.userToEnrollId,
    this.notificationDate,
    this.notificationType,
    this.response,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'CREATOR_ID': creatorId,
      'JAMIYA_ID': jamiyaId,
      'PARTICIPANT_ID': userToEnrollId,
      'REQUEST_DATE': notificationDate,
      'NOTIFICATION_TYPE':notificationType,
      'RESPONSE': response,
    };
    return map;
  }
  Map<String, dynamic> toMapWithId() {
    final map = <String, dynamic>{
      'ID' : id,
      'CREATOR_ID': creatorId,
      'JAMIYA_ID': jamiyaId,
      'PARTICIPANT_ID': userToEnrollId,
      'REQUEST_DATE': notificationDate,
      'NOTIFICATION_TYPE':notificationType,
      'RESPONSE': response,
    };
    return map;
  }

  factory MyNotification.fromMap(Map<String, dynamic> map) {
    return MyNotification(
      map['ID'].toString(),
      map['JAMIYA_ID'],
      map['CREATOR_ID'],
      map['PARTICIPANT_ID'],
      map['REQUEST_DATE'],
      map['NOTIFICATION_TYPE'],
      map['RESPONSE'],
    );
  }
}
