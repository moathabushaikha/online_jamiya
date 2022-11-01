import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:provider/provider.dart';
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
              itemCount: manager.jamiyaItems.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                DateTime startDate = manager.jamiyaItems[index].startingDate;
                int numberOfParticipants = int.parse(
                    '${manager.jamiyaItems[index].participantsId?.length}');
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
                  onTap: () {
                    context.goNamed(
                      'jamiya',
                      params: {'tab': '1', 'selectedJamiyaId': '$index'},
                    );
                  },
                  child: Card(
                    color: Colors.green,
                    borderOnForeground: true,
                    elevation: 10,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.orange),
                            ),
                          ),
                          child: Text(
                            'Name: ${manager.jamiyaItems[index].name} '
                            'created by: ${manager.jamiyaItems[index].creatorId}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: 16, top: 10, right: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 2, color: Colors.orange),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Shared Amount : ${manager.jamiyaItems[index].shareAmount}'),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                      'maximum participants ${manager.jamiyaItems[index].maxParticipants}'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, bottom: 16, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Starting in: $formattedSDate',
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      'Ending in : $formattedEDate',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                'participants : ${manager.jamiyaItems[index].participantsId}')
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // register current user to selected jamiya
                            List<String> participants =
                                manager.jamiyaItems[index].participantsId;
                            if (!participants
                                .contains(widget.currentUser?.id)) {
                              participants
                                  .removeWhere((element) => element == '');
                              participants.add('${widget.currentUser?.id}');
                              manager.updateItem(manager.jamiyaItems[index],index);
                            }
                          },
                          child: const Text('Enroll'),
                        ),
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
          elevation: 0,
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: () {
              context.goNamed(
                'newJamiya', // JamiyaForm
                params: {
                  'tab': '1',
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
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
