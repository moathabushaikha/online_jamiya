import 'models.dart';

class EnrollModel {
  String jamiyaId;
  String creatorId;
  String userToEnrollId;
  String notificationDate;
  String response;

  EnrollModel(
    this.jamiyaId,
    this.creatorId,
    this.userToEnrollId,
    this.notificationDate,
    this.response,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'CREATOR_ID': creatorId,
      'JAMIYA_ID': jamiyaId,
      'PARTICIPANT_ID': userToEnrollId,
      'REQUEST_DATE': notificationDate,
      'RESPONSE': response,
    };
    return map;
  }

  factory EnrollModel.fromMap(Map<String, dynamic> map) {
    return EnrollModel(
      map['CREATOR_ID'],
      map['JAMIYA_ID'],
      map['PARTICIPANT_ID'],
      map['REQUEST_DATE'],
      map['RESPONSE'],
    );
  }
}
