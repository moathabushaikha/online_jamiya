import 'package:flutter/material.dart';
import 'package:online_jamiya/managers/jamiya_manager.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/api/api.dart';

class ChangeParticipantsOrder extends StatefulWidget {
  final Jamiya? jamiya;

  const ChangeParticipantsOrder(this.jamiya, {Key? key}) : super(key: key);

  @override
  State<ChangeParticipantsOrder> createState() => _ChangeParticipantsOrderState();
}

class _ChangeParticipantsOrderState extends State<ChangeParticipantsOrder> {
  List<User?>? jamiyaUsers;
  List? allJamiyaPayments;
  ApiMongoDb apiMongoDb = ApiMongoDb();

  @override
  void initState() {
    getJamiyaParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 75,
        ),
        jamiyaUsers != null
            ? SizedBox(
                width: 200,
                height: 400,
                child: jamiyaUsers!.length == 0
                    ? const Center(
                        child: Text('لا يوجد مستخدمين مسجلين'),
                      )
                    : ReorderableListView(
                        scrollDirection: Axis.vertical,
                        header: const Text(
                          'hold and drag user to change order',
                          style: TextStyle(fontSize: 22),
                        ),
                        children: [
                          for (final tile in jamiyaUsers!)
                            Center(
                              key: ValueKey(tile),
                              child: Container(
                                  width: 200,
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
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${tile?.firstName} ${tile?.lastName}',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Expanded(
                                          child: SizedBox(
                                        width: 25,
                                      )),
                                      const Icon(Icons.move_down)
                                    ],
                                  )),
                            )
                        ],
                        onReorder: (oldIndex, newIndex) => updateOrder(oldIndex, newIndex),
                      ),
              )
            : Column(
                children: const [
                  Text('getting participants'),
                  CircularProgressIndicator(),
                ],
              ),
        ElevatedButton(
            onPressed: () async{
              if (jamiyaUsers != null && allJamiyaPayments != null) {
                int i = 0;
                for (final user in jamiyaUsers!) {
                  widget.jamiya!.participantsId[i] = user!.id;
                  i++;
                }
              }
              // await apiMongoDb.updatePaymentDatesOrder(allJamiyaPayments, widget.jamiya);
              if (mounted) {
                Provider.of<JamiyaManager>(context, listen: false)
                  .updateItem(widget.jamiya as Jamiya);
              }
            },
            child: const Text(
              'Confirm Order',
              style: TextStyle(fontSize: 22),
            ))
      ],
    );
  }

  void getJamiyaParticipants() async {
    List<User> participants = await apiMongoDb.getJamiyaRegisteredUsers(widget.jamiya);
    List<dynamic> jamiyaPayments = await apiMongoDb.getJamiyaPayments(widget.jamiya);

    if (mounted) {
      setState(() {
        jamiyaUsers = participants;
        allJamiyaPayments = jamiyaPayments;
      });
    }
  }

  updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      var jamiyaPayment = allJamiyaPayments?.removeAt(oldIndex);
      allJamiyaPayments?.insert(newIndex, jamiyaPayment);
      final tile = jamiyaUsers?.removeAt(oldIndex);
      jamiyaUsers?.insert(newIndex, tile);
    });
  }
}
