import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class ParticipantsListView extends StatefulWidget {
  final Jamiya selectedJamiya;

  const ParticipantsListView({Key? key, required this.selectedJamiya})
      : super(key: key);

  @override
  State<ParticipantsListView> createState() => _ParticipantsListViewState();
}

class _ParticipantsListViewState extends State<ParticipantsListView> {
  final SqlService sqlService = SqlService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, bottom: 2,top: 6),
      height: 150,
      width: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3,color: Colors.indigo.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Participants'),
          // topArrow ? const Icon(Icons.arrow_drop_down) : const Icon(
          //     Icons.arrow_drop_up),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future:
                  sqlService.getJamiyaRegisteredUsers(widget.selectedJamiya),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}',
                      ),
                    ),
                  );
                } else {
                  return const Text('no data');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
