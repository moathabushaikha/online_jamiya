import 'package:dart_encrypter/dart_encrypter.dart';
import 'package:flutter/material.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required int currentTab}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppCache appCache = AppCache();
  User? currentUser;
  String? msg;
  bool? isDark = false;
  bool personalInfo = false, changeInfo = false, changePassword = false;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController retypedPass = TextEditingController();

  // TextEditingController fName = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text('Profile Page', style: Theme.of(context).textTheme.headline2)),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 160,
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          personalInfo = !personalInfo;
                        });
                      },
                      child: const Text('Personal Data'))),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      Provider.of<ProfileManager>(context, listen: false).darkMode = false;
                      Provider.of<AppStateManager>(context, listen: false).logout();
                    },
                    child: const Text('Log out')),
              ),
              personalInfo
                  ? SizedBox(
                      width: 160,
                      child: Column(
                        children: [
                          SwitchListTile(
                            value: isDark as bool,
                            onChanged: (val) {
                              currentUser?.darkMode = val;
                              Provider.of<ProfileManager>(context, listen: false)
                                  .setUserDarkMode(val);
                              Provider.of<AppStateManager>(context, listen: false)
                                  .updateUser(currentUser as User);
                              Provider.of<AppCache>(context, listen: false)
                                  .setCurrentUser(currentUser as User);
                              setState(() {
                                isDark = val;
                              });
                            },
                            title: const Text('Dark mode'),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  changeInfo = !changeInfo;
                                });
                              },
                              child: const Text('Change Info')),
                          TextField(
                            controller: fName,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'First Name',
                                hintText: currentUser?.firstName),
                            style: const TextStyle(fontSize: 22),
                            enabled: changeInfo,
                            onEditingComplete: () {
                              currentUser?.firstName = fName.text;
                              Provider.of<AppStateManager>(context, listen: false)
                                  .updateUser(currentUser!);
                              Provider.of<AppCache>(context, listen: false)
                                  .setCurrentUser(currentUser!);
                              getCurrentUser();
                            },
                            onSubmitted: (value) {
                              currentUser?.firstName = value;
                              Provider.of<AppStateManager>(context, listen: false)
                                  .updateUser(currentUser!);
                              Provider.of<AppCache>(context, listen: false)
                                  .setCurrentUser(currentUser!);
                              getCurrentUser();
                            },
                          ),
                          TextField(
                            controller: lName,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'last Name',
                                hintText: currentUser?.lastName),
                            style: const TextStyle(fontSize: 22),
                            enabled: changeInfo,
                            onEditingComplete: () {
                              currentUser?.lastName = lName.text;
                              Provider.of<AppStateManager>(context, listen: false)
                                  .updateUser(currentUser!);
                              Provider.of<AppCache>(context, listen: false)
                                  .setCurrentUser(currentUser!);
                              getCurrentUser();
                            },
                            onSubmitted: (value) async {
                              currentUser?.lastName = value;
                              await Provider.of<AppStateManager>(context, listen: false)
                                  .updateUser(currentUser!);
                              if (mounted) {
                                Provider.of<AppCache>(context, listen: false)
                                    .setCurrentUser(currentUser!);
                              }
                              getCurrentUser();
                            },
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      changePassword = !changePassword;
                                    });
                                  },
                                  child: const Text('Change Password'),
                                ),
                                TextField(
                                  controller: password,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(), labelText: 'new password'),
                                  style: const TextStyle(fontSize: 22),
                                  enabled: changePassword,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    TextField(
                                      controller: retypedPass,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Retype password'),
                                      style: const TextStyle(fontSize: 22),
                                      enabled: changePassword,
                                      onChanged: (value) {
                                        setState(() {
                                          msg = null;
                                        });
                                      },
                                      onSubmitted: (newValue) {
                                        if (newValue == password.text &&
                                            newValue.isNotEmpty &&
                                            newValue.length >= 6) {
                                          final String? key =
                                              Security.generatePassword(true, true, true, true, 32);
                                          final String? iv =
                                              Security.generatePassword(true, true, true, true, 16);
                                          String? encryptedPassword =
                                              password.text.encryptMyData(key!, iv!);
                                          currentUser?.password = encryptedPassword;
                                          currentUser?.key = key;
                                          currentUser?.iv = iv;
                                          Provider.of<AppStateManager>(context, listen: false)
                                              .updateUser(currentUser as User);
                                          Provider.of<AppCache>(context, listen: false)
                                              .setCurrentUser(currentUser!);
                                        } else {
                                          if (newValue.isEmpty || newValue.length < 6) {
                                            msg =
                                                'password cannot be empty or shorter than 6 characters ';
                                          }
                                          if (newValue != password.text) {
                                            msg = 'password doesn\'t match';
                                          }
                                        }
                                      },
                                    ),
                                    msg != null
                                        ? Text(
                                            '$msg',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : const Text('')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 160,
                    ),
            ],
          ),
        ),
      ),
    ));
  }

  void getCurrentUser() async {
    User? user = await appCache.getCurrentUser();
    setState(() {
      currentUser = user;
      isDark = user?.darkMode;
    });
  }
}
