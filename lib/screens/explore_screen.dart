import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  AppCache appCache = AppCache();
  String? jamiyaFilter;
  List<Jamiya>? jamiya;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Jamiya name',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) =>
                    setState(() {
                      jamiyaFilter = value;
                    })),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Consumer<JamiyaManager>(builder: (context, manager, child) {
              return FutureBuilder(
                  future: apiMongoDb.filteredJamiya(jamiyaFilter),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Column(
                            children: const [
                              Text('getting jamiyat'),
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator()
                            ],
                          ));
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data == null) {
                      return const Text('لا يوجد جمعيات منشأة');
                    }
                    return JamiyasListView(jamiyas: snapshot.data);
                  });
            }),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          return ElevatedButton(
            onPressed: () => context.goNamed('newJamiya', params: {'tab': '1'}),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
              padding: const EdgeInsets.all(20),
              backgroundColor: profileManager.darkMode
                  ? JamiyaTheme
                  .dark()
                  .backgroundColor
                  : JamiyaTheme
                  .light()
                  .backgroundColor,
            ),
            child: Icon(Icons.add, color: profileManager.darkMode
                ? Colors.white
                : Colors.black),
          );
        },
      ),
    );
  }
}
