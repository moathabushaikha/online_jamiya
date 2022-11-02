import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';

class MainScreen extends StatefulWidget {
  final User? currentUser;
  final JamiyaManager jamiyaManager;
  final AppStateManager appStateManager;
  const MainScreen({Key? key, required this.currentUser, required this.appStateManager,required this.jamiyaManager}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SqlService sqlService = SqlService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  sqlService.getRegisteredJamiyas(widget.currentUser),
      builder: (BuildContext context, AsyncSnapshot<List<Jamiya>> snapShot){
          if (snapShot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MainImageHolder(cUser: widget.currentUser),
                Expanded(
                  child: widget.currentUser?.registeredJamiyaID.length != 0
                      ? RegisteredJamiyaGridView(
                      userRegisteredJamiyas: snapShot.data)
                      : const Text('غير مشترك باي جمعية'),
                ),
              ],
            );
          }else {
            return const Text('غير مشترك باي جمعية');
          }
      },
    );

  }
}

