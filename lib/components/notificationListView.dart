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
            child: Row(children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 45),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FutureBuilder(
                  future: Future.wait([
                    apiMongoDb.getJamiyaById(widget.cUserNotifications[index].jamiyaId),
                    apiMongoDb.getUserById(widget.cUserNotifications[index].notificationCreatorId),
                    apiMongoDb.getUserById(widget.cUserNotifications[index].notificationReceiverId),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Row(
                        children: const [
                          Text('Getting notification'),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        ],
                      );
                    }
                    Jamiya jamiya = snapshot.data?[0] as Jamiya;
                    User requestNotCreator = snapshot.data?[1] as User;
                    User requestNotReceiverUser = snapshot.data?[2] as User;
                    String notificationType = widget.cUserNotifications[index].notificationType;

                    return Column(
                      children: [
                        notificationBody(widget.cUserNotifications[index].notificationType,
                            requestNotCreator, jamiya),
                        widget.cUserNotifications[index].notificationType == 'request'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // approve joining jamiya
                                  ElevatedButton(
                                    style: Theme.of(context).elevatedButtonTheme.style,
                                    onPressed: () async {
                                      User? currentUser = await appCache.getCurrentUser();
                                      String responseDate =
                                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                                      createResponse(widget.cUserNotifications, index, currentUser,
                                          responseDate, requestNotCreator.id);
                                      registerUser(jamiya, requestNotCreator, index);
                                      if (mounted) {
                                        Provider.of<NotificationManager>(context, listen: false)
                                            .deleteNotification(widget.cUserNotifications[index]);
                                      }
                                    },
                                    child: const Icon(Icons.check),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Provider.of<NotificationManager>(context, listen: false)
                                            .deleteNotification(widget.cUserNotifications[index]),
                                    child: const Icon(Icons.close),
                                  ),
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
                                        child: const Icon(Icons.done),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    );
                  },
                ),
              ),
            ]),
          );
        });
  }

  Widget notificationBody(String notificationType, User user, Jamiya jamiya) {
    String message = '';
    if (notificationType == 'request') {
      message = 'wants to join your jamiya ';
    }
    if (notificationType == 'response') {
      message = 'Approved your joining in ';
    }
    if (notificationType == 'remind') {
      message = 'Please pay your share for ';
    }
    return Row(
      children: [Text('${user.firstName} ${user.lastName} '), Text('$message ${jamiya.name}')],
    );
  }

  Future<void> registerUser(Jamiya jamiya, User notCreatorUser, int index) async {
    // check if the notCreatorUser is not joined
    if (!jamiya.participantsId.contains(notCreatorUser.id)) {
      jamiya.participantsId.add(notCreatorUser.id);
      jamiya.endingDate =
          jamiya.startingDate.add(Duration(days: jamiya.participantsId.length * 30));
      notCreatorUser.registeredJamiyaID.add(jamiya.id);
      if (mounted) {
        await Provider.of<JamiyaManager>(context, listen: false).updateItem(jamiya);
      }
      if (mounted) {
        await Provider.of<AppStateManager>(context, listen: false).updateUser(notCreatorUser);
        if (mounted) {
          Provider.of<AppCache>(context, listen: false).setCurrentUser(notCreatorUser);
        }
      }
      await apiMongoDb.initiatePayment(jamiya, notCreatorUser, -1);
      await apiMongoDb.updatePaymentDates(jamiya);
    } else {
      print('user already exist');
    }
  }

  Future<void> createResponse(List<MyNotification> cUserNotification, index, User? currentUser,
      String responseDate, String requestNotCreator) async {
    MyNotification responseNotification = MyNotification(
        id: '',
        jamiyaId: widget.cUserNotifications[index].jamiyaId,
        notificationCreatorId: currentUser!.id,
        notificationReceiverId: requestNotCreator,
        notificationDate: responseDate,
        notificationType: 'response');
    if (mounted) {
      await Provider.of<NotificationManager>(context, listen: false)
          .addNotification(responseNotification);
    }
  }
}
