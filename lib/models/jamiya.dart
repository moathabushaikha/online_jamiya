import 'dart:convert';
import 'package:intl/intl.dart';
import 'models.dart';

Jamiya jamiyaFromJson(String str) => Jamiya.fromMap(json.decode(str));

String jamiyaToJson(Jamiya data) => json.encode(data.toMap());

String jamiyaToMap(Jamiya data) => json.encode(data.toJson());

class Jamiya {
  String id;
  String name;
  DateTime startingDate;
  DateTime endingDate;
  int maxParticipants;
  List<String> participantsId;
  String? creatorId;
  int shareAmount;

  Jamiya(this.id, this.participantsId,
      {required this.name,
      required this.startingDate,
      required this.endingDate,
      required this.maxParticipants,
      required this.creatorId,
      required this.shareAmount});

  Map<String, dynamic> toJson() {
    var formatter = DateFormat('yyyy-MM-dd');
    final map = <String, dynamic>{
      JamiyaTable.name: name,
      JamiyaTable.startingDate: formatter.format(startingDate),
      JamiyaTable.endingDate: formatter.format(endingDate),
      JamiyaTable.shareAmount: shareAmount,
      JamiyaTable.maxParticipants: maxParticipants,
      JamiyaTable.participantsId: participantsId.join(','),
      JamiyaTable.creatorId: creatorId,
    };
    return map;
  }

  Map<String, dynamic> toMap() {
    var formatter = DateFormat('yyyy-MM-dd');
    final map = <String, dynamic>{
      JamiyaTable.startingDate: formatter.format(startingDate),
      JamiyaTable.name: name,
      JamiyaTable.endingDate: formatter.format(endingDate),
      JamiyaTable.shareAmount: shareAmount.toString(),
      JamiyaTable.maxParticipants: maxParticipants.toString(),
      JamiyaTable.participantsId: participantsId.join(","),
      JamiyaTable.creatorId: creatorId,
    };
    return map;
  }

  factory Jamiya.fromMap(Map<String, dynamic> json) {
    List<dynamic> _participantsId = json[JamiyaTable.participantsId];
    List<String> users = [];
    for (var i = 0; i<_participantsId.length;i++)
      {
        users.add(_participantsId[i]);
      }
    return Jamiya(
      json['_id'].$oid,
      users,
      name: json[JamiyaTable.name],
      startingDate: json[JamiyaTable.startingDate],
      endingDate: json[JamiyaTable.endingDate],
      maxParticipants: json[JamiyaTable.maxParticipants],
      creatorId: json[JamiyaTable.creatorId],
      shareAmount: json[JamiyaTable.shareAmount],
    );
  }
}
