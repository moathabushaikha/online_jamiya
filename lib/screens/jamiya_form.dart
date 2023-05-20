import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:provider/provider.dart';

class JamiyaForm extends StatefulWidget {
  const JamiyaForm({
    Key? key,
  }) : super(key: key);

  @override
  State<JamiyaForm> createState() => _JamiyaFormState();
}

class _JamiyaFormState extends State<JamiyaForm> {
  final TextEditingController _jamiyaName = TextEditingController();
  final TextEditingController _shareAmount = TextEditingController();
  final TextEditingController _maxParticipants = TextEditingController();
  DateTime dateTimeFrom = DateTime.now();
  AppCache appCache = AppCache();
  User? currentUser;
  ApiMongoDb apiMongoDb = ApiMongoDb();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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
      appBar: AppBar(title: const Text('Create Jamiya'),),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              'الرجاء ادخال معلومات الجمعية',
              style: Theme.of(context).textTheme.headline1,
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
                OutlinedButton(
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    setState(() {
                      dateTimeFrom = date;
                    });
                  },
                  child: Row(
                    children: [
                      Text('${dateTimeFrom.year}/${dateTimeFrom.month}/${dateTimeFrom.day}'),
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
              width: MediaQuery.of(context).size.width / 4,
              child: OutlinedButton(
                style: Theme.of(context).outlinedButtonTheme.style,
                child: const Text(
                  'create jamiya',
                ),
                onPressed: () async {
                  Jamiya newJamiya = Jamiya(
                    '1',
                    [],
                    name: _jamiyaName.text,
                    startingDate: dateTimeFrom,
                    endingDate: dateTimeFrom,
                    maxParticipants: int.parse(_maxParticipants.text.toString()),
                    creatorId: currentUser?.id,
                    shareAmount: int.parse(_shareAmount.text),
                  );
                  Jamiya? createdJamiya = await Provider.of<JamiyaManager>(context, listen: false)
                      .addJamiyaItem(newJamiya);
                  if (createdJamiya == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Creating Jamiya'),
                        content: const SingleChildScrollView(
                          child: Text('A Jamiya with same name already exist'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Edit')),
                        ],
                      ),
                      barrierDismissible: true,
                    );
                  }
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Creating Jamiya'),
                        content: const SingleChildScrollView(
                          child: Text('Jamiya created successfully'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.goNamed('home', params: {'tab': '${JamiyaTabs.explore}'});
                              },
                              child: const Text('go to Jamiyat')),
                        ],
                      ),
                      barrierDismissible: true,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTimeFrom,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1000)),
      );

  void getCurrentUser() async {
    await appCache.getCurrentUser().then((value) => setState(() => currentUser = value));
  }
}
