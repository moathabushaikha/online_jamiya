import 'package:flutter/material.dart';
import 'package:online_jamiya/managers/jamiya_manager.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';
import 'components.dart';

class EditMyJamiya extends StatefulWidget {
  final Jamiya jamiya;
  final int tab;

  const EditMyJamiya({Key? key, required this.jamiya, required this.tab}) : super(key: key);

  @override
  State<EditMyJamiya> createState() => _EditMyJamiyaState();
}

class _EditMyJamiyaState extends State<EditMyJamiya> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Text('Change participants order'),
                Text('Show Schedule'),
              ],
            ),
            title: Text('Editing ${widget.jamiya.name} Jamiya'),
          ),
          body: Center(
            child: TabBarView(
              children: [
                ChangeParticipantsOrder(widget.jamiya),
                Consumer<JamiyaManager>(
                    builder: (context, value, child) => JamiyaSchedule(widget.jamiya))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
