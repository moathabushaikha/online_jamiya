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
  List<Jamiya>? userRegisteredJamiyas;
  SqlService sqlService = SqlService();
  ApiService apiService = ApiService();
  List<MyNotification> currentUserNotifications = [];

  @override
  Widget build(BuildContext context) {
    // print('home');
    final ctUser = Provider.of<AppStateManager>(context).currentUser;
    List<Widget> pages = <Widget>[
      MainScreen(currentUser: ctUser),
      ExploreScreen(currentUser: ctUser),
    ];
    Widget profileButton(int currentTab) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          child: Center(
            child: CircleAvatar(
                backgroundImage: ctUser!.imgUrl.isNotEmpty
                    ? FileImage(File(ctUser.imgUrl), scale: 0.5)
                    : const AssetImage(
                        'assets/profile_images/profile_image.png',
                      ) as ImageProvider),
          ),
          onTap: () {
            context.goNamed('profile', params: {'tab': '$currentTab'});
          },
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
            Consumer<NotificationManager>(
              builder: (context, notificationManager, child) {
                return FutureBuilder(
                  future: apiService.getAllNotifications(),
                  builder: (context, AsyncSnapshot<List<MyNotification>?> snapshot) {
                    currentUserNotifications = [];
                    if (snapshot.data != null) {
                      for (var i = 0; i < snapshot.data!.length; i++) {
                        if (snapshot.data![i].userToNoti == ctUser?.id) {
                          currentUserNotifications.add(snapshot.data![i]);
                        }
                      }
                      Provider.of<NotificationManager>(context, listen: false)
                          .setNotifications(currentUserNotifications);
                    }
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: currentUserNotifications.isNotEmpty ? Colors.red : Colors.green,
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Text('${currentUserNotifications.length}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    }

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
}
