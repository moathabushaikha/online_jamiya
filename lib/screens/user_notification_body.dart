import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class UserNotificationBody extends StatefulWidget {
  const UserNotificationBody({Key? key, required int currentTab})
      : super(key: key);

  @override
  State<UserNotificationBody> createState() => _UserNotificationBodyState();
}

class _UserNotificationBodyState extends State<UserNotificationBody> {
  final sqlService = SqlService();
  final appCache = AppCache();
  final listKey = GlobalKey<AnimatedListState>();
  Jamiya? jamiya;
  User? userToEnroll;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<NotificationManager>(
        builder: (context, notManager, child) {
          return ListView.builder(
            itemCount: notManager.notifications.length,
            itemBuilder: (context, index) {
              int id = int.parse(
                  (notManager.notifications[index].userToEnrollId).toString());
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notification ${index + 1}'),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: sqlService.readSingleJamiya(
                              notManager.notifications[index].jamiyaId),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              jamiya = snapshot.data;
                              return Text(
                                'jamiya: ${jamiya?.name}',
                              );
                            } else {
                              return const Text('no jamiya found');
                            }
                          }),
                        ),
                        FutureBuilder(
                          future: sqlService.readSingleUser(id),
                          builder: ((context, snapshot) {
                            userToEnroll = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userToEnroll?.firstName} ${userToEnroll?.lastName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                notManager.notifications[index].response ==
                                        'request'
                                    ? const Text(' wants to join')
                                    : const Text('approved to join jamiya')
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                    notManager.notifications[index].response == 'request'
                        ? Row(
                            children: [
                              ElevatedButton(
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                                child: const Text('Approve'),
                                onPressed: () async {
                                  User? currentUser;
                                  await appCache
                                      .getCurrentUser()
                                      .then((value) => currentUser = value);
                                  List<String>? participants =
                                      jamiya?.participantsId;
                                  List<String>? userJamiyat =
                                      userToEnroll?.registeredJamiyaID;
                                  if (!participants!
                                      .contains(userToEnroll?.id)) {
                                    participants.removeWhere(
                                        (element) => element == '');
                                    userJamiyat?.removeWhere(
                                        (element) => element == '');
                                    participants.add('${userToEnroll?.id}');
                                    userToEnroll?.registeredJamiyaID
                                        .add('${jamiya?.id}');
                                    DateTime? endDate = jamiya?.startingDate
                                        .add(Duration(
                                            days: 30 * participants.length));
                                    jamiya?.endingDate = endDate!;
                                    String notificationDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());
                                    MyNotification newNotification =
                                        MyNotification(
                                            '1',
                                            jamiya!.id,
                                            userToEnroll!.id,
                                            currentUser!.id,
                                            notificationDate,
                                            'response',
                                            'true');
                                    if (mounted) {
                                      Provider.of<JamiyaManager>(context,
                                              listen: false)
                                          .updateItem(jamiya!);
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .updateUser(userToEnroll!);
                                      Provider.of<NotificationManager>(context,
                                              listen: false)
                                          .deleteNotification(
                                              notManager.notifications[index]);
                                      Provider.of<NotificationManager>(context,
                                              listen: false)
                                          .addNotification(newNotification);
                                    }
                                  }
                                  //ToDo else add message user already enrolled
                                },
                              ),
                              ElevatedButton(
                                  onPressed: () =>
                                      Provider.of<NotificationManager>(context,
                                              listen: false)
                                          .deleteNotification(
                                              notManager.notifications[index]),
                                  child: const Text('Ignore')),
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
