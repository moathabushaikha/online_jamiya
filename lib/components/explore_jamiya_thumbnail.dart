import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';
import '../managers/managers.dart';

class ExploreJamiyaThumbnail extends StatelessWidget {
  final Jamiya? jamiya;
  final User? currentUser;
  final ApiMongoDb apiMongoDb = ApiMongoDb();

  ExploreJamiyaThumbnail({Key? key, required this.jamiya, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = jamiya?.startingDate;
    String formattedSDate = DateFormat('dd/MM/yyyy').format(startDate!);
    String formattedEDate = DateFormat('dd/MM/yyyy').format(jamiya!.endingDate);
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: Theme.of(context).cardColor,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '${jamiya?.name}',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: FutureBuilder(
                future: apiMongoDb.getUserById(jamiya!.creatorId!),
                builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? const Text('fetching creator name')
                    : Row(
                        children: [
                          const Text('Creator: '),
                          Text('${snapshot.data?.firstName} ',
                              style: Theme.of(context).textTheme.bodyText2,),
                          Text('${snapshot.data?.lastName}',
                            style: Theme.of(context).textTheme.bodyText2,),
                        ],
                      ),
              ),
            ),
            Text(
              'Shared Amount: ${jamiya?.shareAmount} JD',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'Participants: ${jamiya?.participantsId.length}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'Starting: $formattedSDate',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'Ending: $formattedEDate',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () async {
                    // check if the user is not already enrolled in the jamiya
                    if (jamiya!.participantsId.contains(currentUser?.id)) {
                      messageDialog('Enroll Control', 'you already enrolled', context);
                      return;
                    }
                    // send request to join notification to jamiya creator
                    MyNotification newNotification = MyNotification(
                        id: '1',
                        jamiyaId: jamiya!.id,
                        notificationCreatorId: currentUser!.id,
                        notificationReceiverId: jamiya!.creatorId!,
                        notificationDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        notificationType: 'request');
                    Provider.of<NotificationManager>(context, listen: false)
                        .addNotification(newNotification);
                  },
                  child: Text('Enroll', style: Theme.of(context).textTheme.button),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> messageDialog(String title, String message, var context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
