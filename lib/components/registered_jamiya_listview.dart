import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/models/models.dart';
import 'components.dart';

class RegisteredJamiyaListView extends StatelessWidget {
  const RegisteredJamiyaListView({Key? key, required this.userRegisteredJamiyas, required this.currentUser}) : super(key: key);
  final List<Jamiya>? userRegisteredJamiyas;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return userRegisteredJamiyas != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final jamiya = userRegisteredJamiyas?[index];
              return Column(
                children: [
                  Center(
                      child: Text(
                    'press any jamiya to pay',
                    style: Theme.of(context).textTheme.headline2,
                  )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed('paymentPage', params: {'tab': '0'}, extra: {"jamiya": jamiya,"user":currentUser});
                      },
                      child: JamiyaThumbnail(jamiya: jamiya),
                    ),
                  ),
                ],
              );
            },
            padding: const EdgeInsets.all(8),
            itemCount: userRegisteredJamiyas?.length,
          )
        : Center(
            child: Text(
              'لا يوجد لديك جمعيات مسجلة',
              style: Theme.of(context).textTheme.headline2,
            ),
          );
  }
}
