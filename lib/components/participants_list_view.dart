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

  // ScrollController _controller = ScrollController();
  // bool topArrow = false,
  //     downArrow = false;
  //
  // @override
  // void initState() {
  //   _controller = ScrollController();
  //   _controller.addListener(_scrollListener);
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   _controller.removeListener(() {
  //     _scrollListener();
  //   });
  //   topArrow = false;
  //   downArrow = false;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, bottom: 2),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 1, color: Colors.black),
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
                    // controller: _controller,
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

// void _scrollListener() {
//   if (_controller.offset >= _controller.position.maxScrollExtent &&
//       !_controller.position.outOfRange) {
//     setState(() {
//       downArrow = false;
//       topArrow = true;
//     });
//   }
//   if (_controller.offset <= _controller.position.minScrollExtent &&
//       !_controller.position.outOfRange) {
//     setState(() {
//       topArrow = false;
//       downArrow = true;
//     });
//   }
// }
}
