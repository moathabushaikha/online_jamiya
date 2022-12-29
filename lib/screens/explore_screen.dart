import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExploreScreen extends StatefulWidget {
  final User? currentUser;

  const ExploreScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // SqlService sqlService = SqlService();
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // print('explore');
    Provider.of<JamiyaManager>(context).getJamiyat();
    return Scaffold(
      body:
          // #create a consumer when user asks to enroll to a specific jamiya and approved it will rebuild#
          Consumer<JamiyaManager>(
        builder: (context, manager, child) {
          if (manager.jamiyaItems.isNotEmpty) {
            // # list of all created jamiyas #
            return ListView.builder(
              shrinkWrap: true,
              itemCount: manager.jamiyaItems.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                // fixing the participantId string if null remove the empty space
                manager.jamiyaItems[index].participantsId.removeWhere((element) => element == '');
                int numberOfParticipants =
                    int.parse('${manager.jamiyaItems[index].participantsId.length}');
                // add months to jamiya duration equals to number of participants
                DateTime startDate = manager.jamiyaItems[index].startingDate;
                DateTime endDate = startDate.add(Duration(days: 30 * numberOfParticipants));
                // updating Jamiya ending date
                manager.jamiyaItems[index].endingDate = endDate;
                apiService.updateJamiya(manager.jamiyaItems[index]);
                // sqlService.updateJamiya(manager.jamiyaItems[index]);
                // changing the format of jamiya (creation, ending) date for the listView item
                String formattedSDate = DateFormat('dd/MM/yy').format(startDate);
                String formattedEDate = DateFormat('dd/MM/yy').format(endDate);

                return InkWell(
                  onTap: () => context
                      .goNamed('jamiya', params: {'tab': '1', 'selectedJamiyaId': '${index + 1}'}),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(manager.jamiyaItems[index].name,
                                    style: Theme.of(context).textTheme.headline1),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FutureBuilder(
                                    // future: sqlService.readSingleUser(
                                    //     int.parse(manager.jamiyaItems[index].creatorId.toString())),
                                    future: apiService.getUserById(
                                        manager.jamiyaItems[index].creatorId.toString()),
                                    builder: (context, snapshot) => Text(
                                      'creator : ${snapshot.data?.firstName} ${snapshot.data?.lastName}',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Shared Amount : ${manager.jamiyaItems[index].shareAmount}',
                                      style: Theme.of(context).textTheme.bodyText2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      'maximum participants ${manager.jamiyaItems[index].maxParticipants}',
                                      style: Theme.of(context).textTheme.bodyText2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Starting in : $formattedSDate',
                                      style: Theme.of(context).textTheme.bodyText2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Ending in: $formattedEDate',
                                      style: Theme.of(context).textTheme.bodyText2),
                                ],
                              ),
                            ),
                            ParticipantsListView(selectedJamiya: manager.jamiyaItems[index]),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                            ),
                            ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () async {
                                // check if the user is not already enrolled in the jamiya
                                if (isUserEnrolled(
                                    manager.jamiyaItems[index], widget.currentUser)) {
                                  messageDialog('Enroll Control', 'you already enrolled');
                                  return;
                                }
                                // check if the user already sent a request to join
                                if (await notificationExist(
                                    widget.currentUser?.id, manager.jamiyaItems[index])) {
                                  messageDialog('Enroll Control', 'you already send a request');
                                  return;
                                }
                                // send request to join notification to jamiya creator
                                MyNotification newNotification = MyNotification(
                                    '1',
                                    manager.jamiyaItems[index].id,
                                    manager.jamiyaItems[index].creatorId!,
                                    widget.currentUser!.id,
                                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                    'request');
                                if (mounted) {
                                  Provider.of<NotificationManager>(context, listen: false)
                                      .addNotification(newNotification);
                                }
                              },
                              child: Text('Enroll', style: Theme.of(context).textTheme.button),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () async {
                                // register current user to selected jamiya
                                List<String> participants =
                                    manager.jamiyaItems[index].participantsId;
                                List<String>? userJamiyat = widget.currentUser?.registeredJamiyaID;
                                if (participants.contains(widget.currentUser?.id)) {
                                  participants.removeWhere((element) => element == '');
                                  userJamiyat?.removeWhere((element) => element == '');
                                  participants
                                      .removeWhere((element) => element == widget.currentUser?.id);
                                  DateTime endDate =
                                      startDate.subtract(Duration(days: 30 * participants.length));
                                  // updating Jamiya ending date
                                  manager.jamiyaItems[index].endingDate = endDate;
                                  await manager.updateItem(manager.jamiyaItems[index]);
                                  widget.currentUser?.registeredJamiyaID.removeWhere(
                                    (element) => element == manager.jamiyaItems[index].id,
                                  );
                                  if (mounted) {
                                    Provider.of<AppStateManager>(context, listen: false)
                                        .updateUser(widget.currentUser!);
                                  }
                                }
                              },
                              child: Text(
                                'Leave',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('لا يوجد جمعيات'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: Consumer<ProfileManager>(
          builder: (context, profileManager, child) {
            return ElevatedButton(
              onPressed: () => context.goNamed('newJamiya', params: {'tab': '1'}),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
                padding: const EdgeInsets.all(20),
                backgroundColor: profileManager.darkMode
                    ? JamiyaTheme.dark().backgroundColor
                    : JamiyaTheme.light().backgroundColor,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  bool isUserEnrolled(Jamiya selectedJamiya, User? userToEnroll) {
    if (selectedJamiya.participantsId.contains(userToEnroll?.id)) return true;
    return false;
  }

  Future<bool> notificationExist(String? userFromId, Jamiya selectedJamiya) async {
    List<MyNotification>? allNotifications = await apiService.getAllNotifications();
    for (int i = 0; i < allNotifications.length; i++) {
      if (allNotifications[i].jamiyaId == selectedJamiya.id) {
        if (allNotifications[i].userFromNoti == userFromId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<String?> messageDialog(String title, String message) {
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
