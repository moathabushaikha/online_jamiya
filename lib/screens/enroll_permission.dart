import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class EnrollPermission extends StatefulWidget {
  const EnrollPermission({Key? key, required int currentTab}) : super(key: key);

  @override
  State<EnrollPermission> createState() => _EnrollPermissionState();
}

class _EnrollPermissionState extends State<EnrollPermission> {
  SqlService sqlService = SqlService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: sqlService.allNotifications(),
        builder: (context, AsyncSnapshot<List<EnrollModel>> snapshot) {
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Column(children: [
                Text(snapshot.data![index].creatorId),
                Text(snapshot.data![index].userToEnrollId),
                Text(snapshot.data![index].jamiyaId),
                Text(snapshot.data![index].response),
                Text(snapshot.data![index].notificationDate),
              ],),
            ),
          );
        },
      ),
    );
  }
}
