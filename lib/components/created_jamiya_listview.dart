import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/models/models.dart';
import 'components.dart';

class CreatedJamiyaList extends StatelessWidget {
  const CreatedJamiyaList({Key? key, required this.userRegisteredJamiyas}) : super(key: key);
  final List<Jamiya>? userRegisteredJamiyas;

  @override
  Widget build(BuildContext context) {
    return userRegisteredJamiyas != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final jamiya = userRegisteredJamiyas?[index];
              return GestureDetector(
                onTap: (){
                  context.goNamed('editMyJamiya', params: {'tab':'0',},extra: jamiya);
                },
                  child: JamiyaThumbnail(jamiya: jamiya));
            },
            padding: const EdgeInsets.all(8),
            itemCount: userRegisteredJamiyas?.length,
          )
        : Center(
            child: Text(
              'لم تقم بإنشاء اي جمعية ',
              style: Theme.of(context).textTheme.headline2,
            ),
          );
  }
}
