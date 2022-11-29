import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';

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
      future:  sqlService.getUserRegisteredJamiyas(widget.currentUser),
      builder: (BuildContext context, AsyncSnapshot<List<Jamiya>> snapShot){
          if (snapShot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainImageHolder(cUser: widget.currentUser),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration:BoxDecoration(
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
                    child: Text('جمعياتي',style: Theme.of(context).textTheme.headline2,)),
                Expanded(
                  child: widget.currentUser!.registeredJamiyaID.isNotEmpty
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

