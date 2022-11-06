import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/models/models.dart';

class JamiyaView extends StatefulWidget {
  final int selectedJamiyaIndex;
  final JamiyaManager manager;
  final User? user;
  int? currentTab;

  JamiyaView(
      {Key? key,
      required this.user,
      required this.currentTab,
      required this.selectedJamiyaIndex,
      required this.manager})
      : super(key: key);

  @override
  State<JamiyaView> createState() => _JamiyaViewState();
}

class _JamiyaViewState extends State<JamiyaView> {
  @override
  Widget build(BuildContext context) {
    widget.manager.getJamiyat();
    String formattedSDate = DateFormat('dd/MM/yy').format(DateTime.now());
    String formattedEDate = DateFormat('dd/MM/yy').format(DateTime.now());
    int participants = 1;
    Jamiya selectedJamiya =
        widget.manager.jamiyaItems[widget.selectedJamiyaIndex-1];

    DateTime sDate = selectedJamiya.startingDate;
    formattedSDate = DateFormat('dd/MM/yy').format(sDate);
    DateTime eDate = selectedJamiya.endingDate;
    formattedEDate = DateFormat('dd/MM/yy').format(eDate);
    participants = int.parse('${selectedJamiya.participantsId.length}');

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
              child: Text(
            'معلومات الجمعية',
            style: Theme.of(context).textTheme.headline1,
          )),
          Expanded(
            child: ListView(
              children: [
                buildDataContainer('رقم الجمعية', selectedJamiya.id),
                buildDataContainer('اسم الجمعية', selectedJamiya.name),
                buildDataContainer(
                    'المشتركين الجمعية', selectedJamiya.participantsId),
                buildDataContainer(
                    'قيمة السهم الجمعية', selectedJamiya.shareAmount),
                buildDataContainer('تبدأ في', formattedSDate),
                buildDataContainer('تنتهي في', formattedEDate),
                buildDataContainer('انشات عن طريق', selectedJamiya.creatorId),
                buildDataContainer(
                    'قيمة الجمعية', selectedJamiya!.shareAmount * participants),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDataContainer(field, data) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '$data',
              style: const TextStyle(fontSize: 26),
            ),
            Text(
              field,
              style: const TextStyle(fontSize: 26),
            ),
          ],
        ));
  }
}
