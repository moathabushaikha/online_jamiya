import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:online_jamiya/managers/managers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String userName = '', password = '';
  bool obscureField = true;

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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'User Name',
                ),
                onSaved: (value) => setState(() => userName = value!),
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
                obscureText: obscureField,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'Password',
                  hintText: 'password',
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscureField = !obscureField),
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ),
                onSaved: (value) => setState(() => password = value!),
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
              OutlinedButton(
                onPressed: () {
                  final isValid = formKey.currentState?.validate();
                  if (isValid!) {
                    formKey.currentState?.save();
                    Provider.of<AppStateManager>(context, listen: false)
                        .login(userName, password, context);
                    // if (!AppStateManager().isLoggedIn){
                    //   messageDialog('Authentication Error','User doesn\'t exist');
                    // }
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.login_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Login'),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  context.goNamed('register');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Register New User'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<String?> messageDialog(String title,String message){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
