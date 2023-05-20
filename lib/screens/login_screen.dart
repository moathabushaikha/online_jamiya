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
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
              colors: [Color.fromRGBO(200, 120, 100, 1), Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/jamiya_assets/jamiya_main_page.jpeg',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.4),
                        floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black, width: 2)),
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      obscureText: obscureField,
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black, width: 2)),
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.4),
                        prefixIconColor: Colors.grey,
                        prefixIcon: const Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => obscureField = !obscureField),
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
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 162,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = formKey.currentState?.validate();
                        if (isValid != null && isValid) {
                          formKey.currentState?.save();
                          int loginResult =
                              await Provider.of<AppStateManager>(context, listen: false)
                                  .login(userName, password);
                          switch (loginResult) {
                            case 1:
                              {
                                if (mounted) {
                                  buildDialog(context, 'Wrong user name check again');
                                }
                                break;
                              }
                            case 2:
                              {
                                if (mounted) {
                                  buildDialog(context, 'Wrong password check again');
                                }
                                break;
                              }
                            case 3:
                              {
                                if (mounted) {
                                  buildDialog(context,
                                      'This device is not registered please reset your password or create new user');
                                }
                                break;
                              }
                          }
                        }
                      },
                      child: SizedBox(
                        width: 80,
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
                    ),
                  ),
                  Container(
                    width: 162,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: ElevatedButton(
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
                  )
                ],
              ),
            ),
          )),
    );
  }

  void buildDialog(BuildContext context, String msg) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication Error'),
          content: SingleChildScrollView(
            child: Text(msg),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> messageDialog(String title, String message) {
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
