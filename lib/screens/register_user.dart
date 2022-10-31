import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final formKey = GlobalKey<FormState>();
  String userName = '',
      firstName = '',
      lastName = '',
      password = '',
      darkMode = '',
      imgUrl = '';
  List<int> friends = [];
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            // user name
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'User Name'),
              onSaved: (value) {
                setState(() {
                  userName = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter user name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            // first name
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'First Name'),
              onSaved: (value) {
                setState(() {
                  firstName = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please first name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            // last name
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Last Name'),
              onSaved: (value) {
                setState(() {
                  lastName = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter last name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            // password
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              onSaved: (value) {
                setState(() {
                  password = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'password cannot be empty or shorter than 6 characters ';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            SwitchListTile(
              value: isDark,
              onChanged: (val) {
                setState(() {
                  isDark = val;
                });
              },
              title: const Text('Dark mode'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                final isValid = formKey.currentState?.validate();
                if (isValid!) {
                  formKey.currentState?.save();
                  User user = User(
                    '-1',
                    userName: userName,
                    firstName: firstName,
                    lastName: lastName,
                    password: password,
                    darkMode: isDark,
                    registeredJamiyaID: [],
                    imgUrl: '',
                  );
                  Provider.of<AppStateManager>(context, listen: false)
                      .register(user);
                }
              },
              child: const Text('Register New User'),
            ),
          ],
        ),
      ),
    );
  }
}
