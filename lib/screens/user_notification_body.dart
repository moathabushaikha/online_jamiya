import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class UserNotificationBody extends StatefulWidget {
  const UserNotificationBody({Key? key, required int currentTab}) : super(key: key);

  @override
  State<UserNotificationBody> createState() => _UserNotificationBodyState();
}

class _UserNotificationBodyState extends State<UserNotificationBody> {
  // final sqlService = SqlService();
  User? currentUser;
  List<MyNotification> cUserNots = [];
  final appCache = AppCache();
  final ApiMongoDb apiMongoDb = ApiMongoDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(onPressed: ()=>setState(() {
          }), child: const Text('Refresh'),),
          FutureBuilder(
            future: apiMongoDb.getCUserNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data != null) {
                return Expanded(child: NotificationListView(cUserNotifications: snapshot.data!));
              } else {
                return const Center(
                  child: Text('لا يوجد اشعارات'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
