import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/api/api_service.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AppCache appCache = AppCache();
  ApiMongoDb apiMongoDb = ApiMongoDb();
  User? currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainImageHolder(currentUser: currentUser),
        Center(
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: Theme.of(context).cardColor,
              ),
              child: Text(
                'جمعياتي',
                style: Theme.of(context).textTheme.headline2,
              )),
        ),
        Expanded(
          child: FutureBuilder(
            future: apiMongoDb.getUserRegisteredJamiyas(currentUser),
            builder: (context, snapshot) =>
                RegisteredJamiyaGridView(userRegisteredJamiyas: snapshot.data),
          ),
        ),
      ],
    );
  }

  void getCurrentUser() async {
    await appCache.getCurrentUser().then((value) => setState(() => currentUser = value));
  }
}
