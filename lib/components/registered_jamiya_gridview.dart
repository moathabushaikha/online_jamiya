import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'components.dart';

class RegisteredJamiyaGridView extends StatelessWidget {
  RegisteredJamiyaGridView({Key? key,required this.userRegisteredJamiyas})
      : super(key: key);
  List<Jamiya>? userRegisteredJamiyas;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        userRegisteredJamiyas != null
            ? Expanded(
          child: GridView.builder(
            itemCount: userRegisteredJamiyas?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 100,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final jamiya = userRegisteredJamiyas?[index];
              return Padding(
                  padding: const EdgeInsets.all(8),
                  child: JamiyaThumbnail(jamiya: jamiya));
            },
          ),
        )
            : Center(
          child: Text(
            'لا يوجد لديك جمعيات مسجلة',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
