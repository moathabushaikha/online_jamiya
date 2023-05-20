import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/managers/app_cache.dart';
import 'package:online_jamiya/managers/jamiya_manager.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class JamiyaSchedule extends StatefulWidget {
  final Jamiya? jamiya;

  const JamiyaSchedule(this.jamiya, {Key? key}) : super(key: key);

  @override
  State<JamiyaSchedule> createState() => _JamiyaScheduleState();
}

class _JamiyaScheduleState extends State<JamiyaSchedule> {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  AppCache appCache = AppCache();
  User? currentUser;
  List<User>? jamiyaParticipants;
  List<Map<String, dynamic>?>? jamiyaPayments;
  DateTime date = DateTime.now();
  int counter = 0;
  bool isPaid = false, allPaid = false, finished = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayFormatted = formatter.format(today);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Today : $todayFormatted',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: constraints.maxWidth * 0.8,
            height: constraints.maxHeight * 0.8,
            child: Scrollbar(
              controller: _controller,
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView.builder(
                  itemCount: jamiyaParticipants?.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    allPaid = false;
                    if (jamiyaPayments != null) {
                      int q = 0;
                      date = jamiyaPayments?[index]?['userPayment']['paymentDates'][index];
                      for (q; q < jamiyaPayments!.length; q++) {
                        if (jamiyaPayments?[q]?['userPayment']['isPaid'][index] == false) {
                          break;
                        }
                      }
                      if (q == jamiyaPayments!.length) {
                        allPaid = true;
                      }
                    }
                    return Container(
                      decoration: BoxDecoration(
                          color: allPaid ? Colors.green : Colors.red,
                          border: Border.all(color: Colors.black, width: 2)),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Order Date: ${formatter.format(date)}'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Turn to: ${jamiyaParticipants?[index].firstName} ${jamiyaParticipants?[index].lastName}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Container(
                            height: 80,
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.all(2),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: jamiyaParticipants?.length,
                              itemBuilder: (context, index2) {
                                if (jamiyaPayments != null) {
                                  for (var a = 0; a < jamiyaParticipants!.length; a++) {
                                    if (jamiyaParticipants?[index2].id ==
                                        jamiyaPayments?[a]?['userPayment']['userId']) {
                                      isPaid = jamiyaPayments?[a]?['userPayment']['isPaid'][index];
                                      break;
                                    }
                                  }
                                }
                                return Container(
                                  margin: const EdgeInsets.all(2),
                                  padding: const EdgeInsets.all(2),
                                  color: index2.isEven ? Colors.white : Colors.grey,
                                  child: Row(
                                    children: [
                                      Text(
                                          '${jamiyaParticipants?[index2].firstName} ${jamiyaParticipants?[index2].lastName} '),
                                      isPaid == true
                                          ? const Expanded(
                                              child: Text(
                                                'Paid',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          : const Expanded(
                                              child: Text(
                                                'Did not pay',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                          width: 80,
                                          child: ElevatedButton(
                                              onPressed: !isPaid
                                                  ? () async {
                                                      MyNotification payReminder = MyNotification(
                                                          id: '',
                                                          jamiyaId: widget.jamiya?.id as String,
                                                          notificationCreatorId:
                                                              currentUser?.id as String,
                                                          notificationReceiverId:
                                                              jamiyaParticipants?[index2].id
                                                                  as String,
                                                          notificationDate: todayFormatted,
                                                          notificationType: 'remind');
                                                      await apiMongoDb
                                                          .createNotification(payReminder);
                                                    }
                                                  : null,
                                              child: const Text('Remind'))),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          ElevatedButton(
              onPressed: finished
                  ? () async {
                      Provider.of<JamiyaManager>(context, listen: false)
                          .deleteJamiyaItem(widget.jamiya);
                      apiMongoDb.deleteJamiyaPayment(widget.jamiya);
                    }
                  : null,
              child: const Text('close jamiya'))
        ]);
      },
    );
  }

  void fetchData() async {
    List<User> participants = await apiMongoDb.getJamiyaRegisteredUsers(widget.jamiya);
    List<Map<String, dynamic>?> payments = await apiMongoDb.getJamiyaPayments(widget.jamiya);
    currentUser = await appCache.getCurrentUser();
    setState(() {
      jamiyaParticipants = participants;
      jamiyaPayments = payments;
      checkStatus();
    });
  }

  void checkStatus() {
    if (jamiyaPayments != null) {
      int i = 0, j = 0;
      for (i; i < jamiyaParticipants!.length; i++) {
        for (j; j < jamiyaPayments!.length; j++) {
          if (jamiyaPayments?[i]?['userPayment']['isPaid'][j] == false) {
            break;
          }
        }
        if (j == jamiyaPayments!.length) {
          counter++;
        }
      }
      if (counter == jamiyaParticipants?.length) {
        setState(() {
          finished = true;
        });
      }
    }
  }
}
