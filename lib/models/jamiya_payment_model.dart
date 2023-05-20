import 'dart:convert';
import 'package:intl/intl.dart';

JamiyaPaymentModel jamiyaPaymentFromJson(String str) => JamiyaPaymentModel.fromMap(json.decode(str));

String jamiyaPaymentToJson(JamiyaPaymentModel data) => json.encode(data.toMap());

class JamiyaPaymentModel {
  String id;
  String jamiyaId;
  String? userId;
  DateTime paymentDate = DateTime.now();
  double paymentAmount;

  JamiyaPaymentModel(this.id,this.paymentDate,
      {required this.jamiyaId, required this.userId, required this.paymentAmount});

  Map<String, dynamic> toMap() {
    var formatter = DateFormat('yyyy-MM-dd');
    final map = <String, dynamic>{
      'jamiyaId': jamiyaId,
      'userId': userId,
      'paymentAmount': paymentAmount,
      'date': formatter.format(paymentDate),
    };
    return map;
  }

  factory JamiyaPaymentModel.fromMap(Map<String, dynamic> json) {
    return JamiyaPaymentModel(json['_id'].$oid as String, DateTime.parse(json['date']),
        jamiyaId: json['jamiyaId'] as String,
        paymentAmount: double.parse(json['paymentAmount']),
        userId: json['userId'] as String);
  }
}
