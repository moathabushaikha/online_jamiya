import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
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
  SqlService sqlService = SqlService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JamiyaManager>(
        builder: (context, manager, child) {
          fillJamiyat(manager);
          if (manager.jamiyaItems.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: manager.jamiyaItems.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                DateTime startDate = manager.jamiyaItems[index].startingDate;
                int numberOfParticipants = int.parse(
                    '${manager.jamiyaItems[index].participantsId.length}');
                DateTime endDate =
                    startDate.add(Duration(days: 30 * numberOfParticipants));
                // updating Jamiya ending date
                manager.jamiyaItems[index].endingDate = endDate;
                sqlService.updateJamiya(manager.jamiyaItems[index]);
                // changing the format of jamiya (creation, ending) date for the listView
                String formattedSDate =
                    DateFormat('dd/MM/yy').format(startDate);
                String formattedEDate = DateFormat('dd/MM/yy').format(endDate);

                return InkWell(
                  onTap: () => context.goNamed('jamiya',
                      params: {'tab': '1', 'selectedJamiyaId': '${index + 1}'}),
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            height: 125,
                            margin: const EdgeInsets.only(bottom: 30),
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                manager.jamiyaItems[index].name,
                                style: JamiyaTheme.lightTextTheme.headline1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                            child: FutureBuilder(
                              future: sqlService.readSingleUser(int.parse(manager.jamiyaItems[index].creatorId.toString())),
                              builder: (context, snapshot) => Text('${snapshot.data?.firstName} ${snapshot.data?.lastName}'),
                            ),
                        ),
                        Positioned(
                          left: 50,
                          top: 30,
                          child: Text(
                              'Shared Amount : ${manager.jamiyaItems[index].shareAmount}'),
                        ),
                        Positioned(
                          left: 50,
                          top: 45,
                          child: Text(
                              'maximum participants ${manager.jamiyaItems[index].maxParticipants}'),
                        ),
                        Positioned(
                          left: 50,
                          top: 65,
                          child: Text(
                            'Starting in : $formattedSDate',
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 85,
                          child: Text(
                            'Ending in: $formattedEDate',
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: ParticipantsListView(
                              selectedJamiya: manager.jamiyaItems[index]),
                          // Text(
                          //   'participants : ${manager.jamiyaItems[index].participantsId}',
                          // ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              // register current user to selected jamiya
                              List<String> participants =
                                  manager.jamiyaItems[index].participantsId;
                              List<String>? userJamiyat =
                                  widget.currentUser?.registeredJamiyaID;
                              if (!participants
                                  .contains(widget.currentUser?.id)) {
                                participants
                                    .removeWhere((element) => element == '');
                                userJamiyat
                                    ?.removeWhere((element) => element == '');
                                participants.add('${widget.currentUser?.id}');
                                DateTime endDate = startDate.add(
                                    Duration(days: 30 * participants.length));
                                // updating Jamiya ending date
                                manager.jamiyaItems[index].endingDate = endDate;
                                await manager.updateItem(
                                    manager.jamiyaItems[index], index);
                                widget.currentUser?.registeredJamiyaID
                                    .add(manager.jamiyaItems[index].id);
                                await AppStateManager()
                                    .updateUser(widget.currentUser!);
                              }
                            },
                            child: const Text('Enroll'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              // register current user to selected jamiya
                              List<String> participants =
                                  manager.jamiyaItems[index].participantsId;
                              List<String>? userJamiyat =
                                  widget.currentUser?.registeredJamiyaID;
                              if (participants
                                  .contains(widget.currentUser?.id)) {
                                participants
                                    .removeWhere((element) => element == '');
                                userJamiyat
                                    ?.removeWhere((element) => element == '');
                                participants.removeWhere((element) =>
                                    element == widget.currentUser?.id);
                                DateTime endDate = startDate.subtract(
                                    Duration(days: 30 * participants.length));
                                // updating Jamiya ending date
                                manager.jamiyaItems[index].endingDate = endDate;
                                await manager.updateItem(
                                    manager.jamiyaItems[index], index);
                                widget.currentUser?.registeredJamiyaID
                                    .removeWhere(
                                  (element) =>
                                      element == manager.jamiyaItems[index].id,
                                );
                                await AppStateManager()
                                    .updateUser(widget.currentUser!);
                              }
                            },
                            child: const Text('Leave'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('nothing');
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: ElevatedButton(
            onPressed: () => context.goNamed('newJamiya', params: {'tab': '1'}),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(
                  side: BorderSide(width: 2, color: Colors.white)),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          )),
    );
  }

  void fillJamiyat(manager) async {
    await manager.getJamiyat();
  }
}
