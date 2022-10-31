import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/models/models.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;
   const ProfileScreen({Key? key, required this.user, required int currentTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.edit_note_outlined))
        ],
      ),
      body: ListView(
        children: [
          Text('Welcome To Your Profile ${user?.firstName}'),
          TextButton(
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false).logout();
              },
              child: const Text('Log out'))
        ],
      ),
    );
  }
}
