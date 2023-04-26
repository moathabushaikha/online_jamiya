import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/jamiya_list_view.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  AppCache appCache = AppCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: apiMongoDb.getJamiyas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: const [Text('getting all jamiyas...'), CircularProgressIndicator()],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null){
              return const Center(child: Text('لا يوجد جمعيات'),);
            }
            return JamiyasListView(jamiyas: snapshot.data);
          }),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: Consumer<ProfileManager>(
          builder: (context, profileManager, child) {
            return ElevatedButton(
              onPressed: () => context.goNamed('newJamiya', params: {'tab': '1'}),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
                padding: const EdgeInsets.all(20),
                backgroundColor: profileManager.darkMode
                    ? JamiyaTheme.dark().backgroundColor
                    : JamiyaTheme.light().backgroundColor,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
      ),
    );
  }


}
