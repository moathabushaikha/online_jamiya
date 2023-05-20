import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:provider/provider.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainImageHolder(currentUser: currentUser),
        Expanded(
            child: Column(children: [
          Column(
            children: [
              Container(
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
                  'الجمعيات المشترك بها',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Consumer<JamiyaManager>(
                builder: (context, manager, child) => FutureBuilder(
                  future: apiMongoDb.getUserRegisteredJamiyas(currentUser),
                  builder: (context, snapshot) {
                    if (snapshot.data == null &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: const [
                            Text('getting your registered jamiyas'),
                            Expanded(
                                child: LinearProgressIndicator(
                              color: Colors.black,
                            ))
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 170,
                        padding: const EdgeInsets.all(5),
                        child: RegisteredJamiyaListView(
                            userRegisteredJamiyas: snapshot.data, currentUser: currentUser),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Column(children: [
            Container(
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
                'الجمعيات المنشأة',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Consumer<JamiyaManager>(
              builder: (context, manager, child) => FutureBuilder(
                  future: apiMongoDb.getUsersCreatedJamiyas(currentUser),
                  builder: (context, snapshot) {
                    if (snapshot.data == null &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: const [
                            Text('getting your registered jamiyas'),
                            Expanded(
                                child: LinearProgressIndicator(
                              color: Colors.black,
                            ))
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 170,
                        padding: const EdgeInsets.all(5),
                        child: CreatedJamiyaList(userRegisteredJamiyas: snapshot.data),
                      );
                    }
                  }),
            )
          ])
        ]))
      ],
    );
  }

  void getCurrentUser() async {
    await appCache.getCurrentUser().then((value) => setState(() => currentUser = value));
  }
}
