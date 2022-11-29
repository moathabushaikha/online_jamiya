import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'components.dart';

class RegisteredJamiyaGridView extends StatelessWidget {
  const RegisteredJamiyaGridView(
      {Key? key, required this.userRegisteredJamiyas})
      : super(key: key);
  final List<Jamiya>? userRegisteredJamiyas;

  @override
  Widget build(BuildContext context) {
    return userRegisteredJamiyas != null
        ? GridView.builder(
            itemBuilder: (context, index) {
              final jamiya = userRegisteredJamiyas?[index];
              return JamiyaThumbnail(jamiya: jamiya);
            },
            padding: const EdgeInsets.all(8),
            itemCount: userRegisteredJamiyas?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
              mainAxisExtent: 125
            ),
          )
        : Center(
            child: Text(
              'لا يوجد لديك جمعيات مسجلة',
              style: Theme.of(context).textTheme.headline2,
            ),
          );
  }
}
