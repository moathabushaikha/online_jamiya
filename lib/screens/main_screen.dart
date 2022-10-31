import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';

class MainScreen extends StatefulWidget {
  User? currentUser;

  MainScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Jamiya>? userRegisteredJamiyas;

  @override
  void initState() {
    super.initState();
    getRegJamiyat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MainImageHolder(cUser: widget.currentUser),
        Expanded(
          child: widget.currentUser?.registeredJamiyaID.length != 0
              ? RegisteredJamiyaGridView(
              userRegisteredJamiyas: userRegisteredJamiyas)
              : Text('no jamiyas'),
        ),
      ],
    );
  }

  void getRegJamiyat() async {
    List<Jamiya>? allRegJamiyas = await SqlService()
        .getRegisteredJamiyas(widget.currentUser?.registeredJamiyaID);
    setState(() {
      userRegisteredJamiyas = allRegJamiyas;
    });
  }
}
