import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class SecondRoute extends StatelessWidget {
  SecondRoute({Key? key}) : super(key: key);
  SqlService sqlService = SqlService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: sqlService.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text('${AppStateManager().currentUser?.userName}'),
                    Text('${snapshot.data?[index].firstName}'),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text('data'),
            );
          }
        },
      ),
    );
  }
}
