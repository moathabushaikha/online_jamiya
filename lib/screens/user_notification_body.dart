import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
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
  final appCache = AppCache();
  final ApiService apiService = ApiService();
  final listKey = GlobalKey<AnimatedListState>();
  List<MyNotification>? cUserNotifications;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCUserNotifications();
  }

  void getCUserNotifications() async {
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> allNotifications = await apiService.getAllNotifications();
    for (var notification in allNotifications) {
      if (notification.userToNoti == currentUser?.id) {
        cUserNotifications?.add(notification);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<NotificationManager>(
        builder: (context, notManager, child) {
          return cUserNotifications?.length != 0
              ? ListView.builder(
                  itemCount: notManager.notifications.length,
                  itemBuilder: (context, index) {
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
                                future: apiService
                                    .getJamiyaById(notManager.notifications[index].jamiyaId),
                                builder: ((context, snapshot) {
                                  Jamiya? jamiya = snapshot.data;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('jamiya name:'),
                                      Text('${jamiya?.name}'),
                                    ],
                                  );
                                }),
                              ),
                              FutureBuilder(
                                future: apiService
                                    .getUserById(notManager.notifications[index].userFromNoti),
                                builder: ((context, snapshot) {
                                  User? userToEnroll = snapshot.data;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userToEnroll?.firstName} ${userToEnroll?.lastName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      notManager.notifications[index].notificationType == 'request'
                                          ? const Text(' wants to join')
                                          : const Text('approved to join jamiya')
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                          notManager.notifications[index].notificationType == 'request'
                              ? Row(
                                  children: [
                                    ElevatedButton(
                                      style: Theme.of(context).elevatedButtonTheme.style,
                                      child: const Text('Approve'),
                                      onPressed: () async {
                                        // add user to the jamiya as participant and add jamiya to user registered jamiyas
                                        User? newNotiSendFrom = await appCache.getCurrentUser();
                                        Jamiya selectedJamiya = await apiService.getJamiyaById(
                                            notManager.notifications[index].jamiyaId);
                                        User newNotifSendTo = await apiService.getUserById(
                                            notManager.notifications[index].userFromNoti);
                                        List<String>? userJamiyat =
                                            newNotifSendTo.registeredJamiyaID;
                                        if (!selectedJamiya.participantsId
                                            .contains(newNotifSendTo.id)) {
                                          selectedJamiya.participantsId
                                              .removeWhere((character) => character == '');
                                          userJamiyat.removeWhere((character) => character == '');
                                          selectedJamiya.participantsId.add(newNotifSendTo.id);
                                          newNotifSendTo.registeredJamiyaID.add(selectedJamiya.id);
                                          if (mounted) {
                                            Provider.of<JamiyaManager>(context, listen: false)
                                                .updateItem(selectedJamiya);
                                            Provider.of<AppStateManager>(context, listen: false)
                                                .updateUser(newNotiSendFrom!);
                                          }
                                        }
                                        // delete approved notification from current user display
                                        if (mounted) {
                                          Provider.of<NotificationManager>(context, listen: false)
                                              .deleteNotification(notManager.notifications[index]);
                                        }
                                        // send approve notification to enrolled user
                                        DateTime? endDate = selectedJamiya.startingDate.add(
                                            Duration(
                                                days: 30 * selectedJamiya.participantsId.length));
                                        selectedJamiya.endingDate = endDate;
                                        String notificationDate =
                                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                                        MyNotification responseNotification = MyNotification(
                                            '1',
                                            selectedJamiya.id,
                                            newNotifSendTo.id,
                                            newNotiSendFrom!.id,
                                            notificationDate,
                                            'response');
                                        if (mounted) {
                                          Provider.of<NotificationManager>(context, listen: false)
                                              .addNotification(responseNotification);
                                        }
                                      },
                                    ),
                                    ElevatedButton(
                                        onPressed: () => Provider.of<NotificationManager>(context,
                                                listen: false)
                                            .deleteNotification(notManager.notifications[index]),
                                        child: const Text('Ignore')),
                                  ],
                                )
                              : SizedBox(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: ElevatedButton(
                                            onPressed: () => Provider.of<NotificationManager>(
                                                    context,
                                                    listen: false)
                                                .deleteNotification(
                                                    notManager.notifications[index]),
                                            child: const Text('Ok')),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('لا يوجد اشعارات'),
                );
        },
      ),
    );
  }
}
