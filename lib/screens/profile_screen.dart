import 'package:flutter/material.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required int currentTab}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppCache appCache = AppCache();
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.edit_note_outlined))
        ],
      ),
      body: FutureBuilder(
          future: appCache.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              isDark = snapshot.data!.darkMode;
            }
            return ListView(
              children: [
                Text(
                    'Welcome To Your Profile ${snapshot.data?.firstName}'
                        ' ${snapshot.data?.lastName} ${snapshot.data?.darkMode} '),
                SwitchListTile(
                  value: isDark,
                  onChanged: (val) async {
                    snapshot.data?.darkMode = val;
                    Provider.of<AppStateManager>(context,listen: false).updateUser(snapshot.data!);
                    Provider.of<ProfileManager>(context,listen: false).setUserDarkMode(snapshot.data!);
                    setState(() {
                      isDark = snapshot.data!.darkMode;
                    });
                  },
                  title: const Text('Dark mode'),
                ),
                TextButton(
                    onPressed: () {
                      Provider.of<ProfileManager>(context, listen: false)
                          .darkMode = false;
                      Provider.of<AppStateManager>(context, listen: false)
                          .logout();
                    },
                    child: const Text('Log out'))
              ],
            );
          }),
    );
  }
}
