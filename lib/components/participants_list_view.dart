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
  final ApiService _apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, bottom: 2,top: 6),
      height: 150,
      width: 135,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3,color: Colors.indigo.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Participants'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future:
            _apiService.getJamiyaRegisteredUsers(widget.selectedJamiya),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data != null ?
                  ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}',
                      ),
                    );}
                  ): const Text('لا يوجد مشتركين');
                } else {
                  return const Text('no users');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
