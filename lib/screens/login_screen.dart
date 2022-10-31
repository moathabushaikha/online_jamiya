import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/models/models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String userName = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(
                child: Image(
                  image: AssetImage(
                    'assets/jamiya_assets/jordanian-dinar.jpg',
                  ),
                ),
              ),
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
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  final isValid = formKey.currentState?.validate();
                  if(isValid!) {
                    formKey.currentState?.save();
                    return Provider.of<AppStateManager>(context, listen: false)
                        .login(userName, password);
                  }
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.goNamed('register');
                },
                child: const Text('Register New User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
