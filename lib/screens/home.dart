import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'screens.dart';

class Home extends StatefulWidget {
  final int currentTab;

  const Home({Key? key, required this.currentTab}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  JamiyaManager manager = JamiyaManager();
  ApiMongoDb apiMongoDb = ApiMongoDb();
  AppCache appCache = AppCache();

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      const MainScreen(),
      const ExploreScreen(),
      // Consumer<JamiyaManager>(builder: (context, manager, child) => const ExploreScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
         notification(widget.currentTab),
          const SizedBox(width: 10),
          Consumer<AppStateManager>(
            builder: (context, value, child) => profileButton(widget.currentTab),
          )
        ],
        title: Text(
          'جمعية اونلاين',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
      body: IndexedStack(
        index: widget.currentTab,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentTab,
        onTap: (index) {
          Provider.of<AppStateManager>(context, listen: false).goToTab(index);
          context.goNamed(
            'home',
            params: {
              'tab': '$index',
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'الجمعيات',
          ),
        ],
      ),
    );
  }

  Widget profileButton(int currentTab) {
    return FutureBuilder(
      future: appCache.getCurrentUser(),
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          child: const Center(
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
          ),
          onTap: () {
            context.goNamed('profile', params: {'tab': '$currentTab'});
          },
        ),
      ),
    );
  }

  Widget notification(int currentTab) {
    return GestureDetector(
      onTap: () => context.goNamed('userNotification', params: {'tab': '$currentTab'}),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Notifications'),
          const SizedBox(width: 10),
          StreamBuilder(
            stream: apiMongoDb.getCuNotStream(),
            builder: (context, AsyncSnapshot<List<MyNotification>?> snapshot) {
              if (snapshot.hasData) {
                // print('here ${snapshot.data!.length}');
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: snapshot.data!.isNotEmpty ? Colors.red : Colors.green,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Text('${snapshot.data!.length}'),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Text('0'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
