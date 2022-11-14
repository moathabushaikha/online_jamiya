import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';

class JamiyaForm extends StatefulWidget {
  final Function(Jamiya) onCreate;
  final int index;

  const JamiyaForm(
      {Key? key,
      required this.onCreate,
      this.index = -1})
      : super(key: key);

  @override
  State<JamiyaForm> createState() => _JamiyaFormState();
}

class _JamiyaFormState extends State<JamiyaForm> {
  final TextEditingController _jamiyaName = TextEditingController();
  final TextEditingController _shareAmount = TextEditingController();
  final TextEditingController _maxParticipants = TextEditingController();
  DateTime dateTimeFrom = DateTime.now();
  final AppCache _appCache = AppCache();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTextField(String hintText, TextEditingController controller) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 1.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(height: 0.5),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              'الرجاء ادخال معلومات الجمعية',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            ),
            const SizedBox(
              height: 16,
            ),
            buildTextField('jamiya name', _jamiyaName),
            const SizedBox(
              height: 16,
            ),
            buildTextField('Maximum number of Participants', _maxParticipants),
            const SizedBox(
              height: 16,
            ),
            buildTextField('Share Amount', _shareAmount),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'تاريخ البدء',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    setState(() {
                      dateTimeFrom = date;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                          '${dateTimeFrom.year}/${dateTimeFrom
                              .month}/${dateTimeFrom.day}'),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.calendar_month_sharp)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 4,
              child: Consumer<ProfileManager>(
                builder: (context,profileManager,child){
                  return MaterialButton(
                    color: profileManager.darkMode ? JamiyaTheme.dark().backgroundColor : JamiyaTheme.light().backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'create jamiya',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Jamiya newJamiya = Jamiya(
                        '1',
                        [],
                        name: _jamiyaName.text,
                        startingDate: dateTimeFrom,
                        endingDate: dateTimeFrom,
                        maxParticipants:
                        int.parse(_maxParticipants.text.toString()),
                        creatorId: currentUser?.id,
                        shareAmount: int.parse(_shareAmount.text),
                      );
                      widget.onCreate(newJamiya);
                      context.goNamed('home',
                          params: {'tab': '${JamiyaTabs.explore}'});
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() =>
      showDatePicker(
          context: context,
          initialDate: dateTimeFrom,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 1000)));

  void getCurrentUser() async {
    User? cUser = await _appCache.getCurrentUser();
    setState(() {
      currentUser = cUser;
    });
  }
}
