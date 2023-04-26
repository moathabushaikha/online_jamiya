import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class NotificationListView extends StatefulWidget {
  final List<MyNotification> cUserNotifications;

  const NotificationListView({Key? key, required this.cUserNotifications}) : super(key: key);

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  final ApiMongoDb apiMongoDb = ApiMongoDb();
  final AppCache appCache = AppCache();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cUserNotifications.length,
      itemBuilder: (context, index) {
        return Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).backgroundColor,
            ),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 45),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: Future.wait([
                            apiMongoDb.getJamiyaById(widget.cUserNotifications[index].jamiyaId),
                            apiMongoDb.getUserById(
                                widget.cUserNotifications[index].notificationCreatorId),
                            apiMongoDb.getUserById(
                                widget.cUserNotifications[index].notificationCreatorId)
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Row(
                                children: const [
                                   Text('Getting notification'),
                                   SizedBox(width: 20,),
                                   Expanded(
                                     child: LinearProgressIndicator(
                                      color: Colors.black,
                                  ),
                                   )
                                ],
                              );
                            }
                            Jamiya jamiya = snapshot.data?[0] as Jamiya;
                            User user = snapshot.data?[1] as User;
                            User notRecieverUser = snapshot.data?[2] as User;
                            return widget.cUserNotifications[index].notificationType == 'request'
                                ? Row(
                                    children: [
                                      Text('${user.firstName} ${user.lastName} '),
                                      const Text('wants to join your jamiya '),
                                      Text(jamiya.name)
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text('${notRecieverUser.firstName} ${notRecieverUser.lastName} '),
                                      Text('Approved you to join  ${jamiya.name}'),
                                    ],
                                  );
                          }),
                      widget.cUserNotifications[index].notificationType == 'request'
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  style: Theme.of(context).elevatedButtonTheme.style,
                                  icon: const Icon(Icons.check),
                                  onPressed: () async {
                                    User? currentUser = await appCache.getCurrentUser();
                                    String responseDate =
                                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                                    String? notiReceiverId =
                                        widget.cUserNotifications[index].notificationCreatorId;
                                    await registerUser(
                                        widget.cUserNotifications, notiReceiverId, index);
                                    await createResponse(widget.cUserNotifications, index,
                                        currentUser, responseDate, notiReceiverId);
                                    if (mounted) {
                                      Provider.of<NotificationManager>(context, listen: false)
                                          .deleteNotification(widget.cUserNotifications[index]);
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    onPressed: () =>
                                        Provider.of<NotificationManager>(context, listen: false)
                                            .deleteNotification(widget.cUserNotifications[index]),
                                    icon: const Icon(Icons.close)),
                              ],
                            )
                          : SizedBox(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton(
                                        onPressed: () => Provider.of<NotificationManager>(context,
                                                listen: false)
                                            .deleteNotification(widget.cUserNotifications[index]),
                                        child: const Icon(Icons.done)),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> registerUser(
      List<MyNotification> cUserNotification, String notiReceiverId, int index) async {
    Jamiya? selectedJamiya =
        await apiMongoDb.getJamiyaById(widget.cUserNotifications[index].jamiyaId);
    if (!selectedJamiya.participantsId.contains(notiReceiverId)) {
      selectedJamiya.participantsId.add(notiReceiverId);
      selectedJamiya.endingDate = selectedJamiya.startingDate
          .add(Duration(days: selectedJamiya.participantsId.length * 30));
      User? notificationReceiver = await apiMongoDb.getUserById(notiReceiverId);
      notificationReceiver.registeredJamiyaID.add(selectedJamiya.id);
      if (mounted) {
        Provider.of<JamiyaManager>(context, listen: false).updateItem(selectedJamiya);
        Provider.of<AppStateManager>(context, listen: false).updateUser(notificationReceiver);
        Provider.of<NotificationManager>(context, listen: false)
            .deleteNotification(widget.cUserNotifications[index]);
      }
    } else {
      print('user already exist');
    }
  }

  Future<void> createResponse(List<MyNotification> cUserNotification, index, User? currentUser,
      String responseDate, String notiReceiverId) async {
    MyNotification responseNotification = MyNotification(
        id: '',
        jamiyaId: widget.cUserNotifications[index].jamiyaId,
        notificationCreatorId: currentUser!.id,
        notificationReceiverId: notiReceiverId,
        notificationDate: responseDate,
        notificationType: 'response');
    if (mounted) {
      Provider.of<NotificationManager>(context, listen: false)
          .addNotification(responseNotification);
    }
  }
}
