import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class JamiyaView extends StatefulWidget {
  final int selectedJamiyaId;

  const JamiyaView(
      {Key? key,
      required User? user,
      required int currentTab,
      required this.selectedJamiyaId})
      : super(key: key);

  @override
  State<JamiyaView> createState() => _JamiyaViewState();
}

class _JamiyaViewState extends State<JamiyaView> {
  SqlService sqlService = SqlService();
  Jamiya? selectedJamiya;

  @override
  void initState() {
    getJamiyaById();
    super.initState();
  }

  Future<void> getJamiyaById() async {
    selectedJamiya =
        await sqlService.readSingleJamiya(widget.selectedJamiyaId.toString());
    setState(() {
      selectedJamiya;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedSDate = DateFormat('dd/MM/yy').format(DateTime.now());
    String formattedEDate = DateFormat('dd/MM/yy').format(DateTime.now());
    if (selectedJamiya != null) {
      DateTime sDate = selectedJamiya!.startingDate;
      formattedSDate = DateFormat('dd/MM/yy').format(sDate);
      DateTime eDate = selectedJamiya!.endingDate;
      formattedEDate = DateFormat('dd/MM/yy').format(eDate);
    }

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
            child: selectedJamiya != null
                ? ListView(
                    children: [
                      buildDataContainer('رقم الجمعية', selectedJamiya!.id),
                      buildDataContainer('اسم الجمعية', selectedJamiya!.name),
                      buildDataContainer(
                          'المشتركين الجمعية', selectedJamiya!.participantsId),
                      buildDataContainer(
                          'قيمة السهم الجمعية', selectedJamiya!.shareAmount),
                      buildDataContainer('تبدأ في', formattedSDate),
                      buildDataContainer('تنتهي في', formattedEDate),
                      buildDataContainer(
                          'انشات عن طريق', selectedJamiya!.creatorId),
                      buildDataContainer(
                          'قيمة الجمعية',
                          selectedJamiya!.shareAmount *
                              selectedJamiya!.participantsId.length),
                    ],
                  )
                : const Text('لا يوجد لديك اي جمعيات'),
          )
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
