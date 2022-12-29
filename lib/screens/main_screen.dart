import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/api/api_service.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';

class MainScreen extends StatefulWidget {
  final User? currentUser;
  const MainScreen({Key? key, required this.currentUser}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainImageHolder(currentUser: widget.currentUser),
        Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
              color: Theme.of(context).cardColor,
            ),
            child: Text(
              'جمعياتي',
              style: Theme.of(context).textTheme.headline2,
            )),
        // Expanded(
        //
        //   child: RegisteredJamiyaGridView(),
        // ),
      ],
    );
  }
}
