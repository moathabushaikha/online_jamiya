import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:go_router/go_router.dart';

class JamiyaThumbnail extends StatelessWidget {
  final Jamiya? jamiya;

  const JamiyaThumbnail({Key? key, required this.jamiya}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(jamiya?.participantsId);
    var x =  jamiya?.participantsId.length as int;
    var y = jamiya?.shareAmount as int;
    int jamiyaAmount = x * y;
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.green),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        onTap: () {
          context.goNamed(
            'jamiya',
            params: {'tab': '0', 'selectedJamiyaId': jamiya!.id},
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: 6,
              left: 6,
              child: Text(
                'Name: ${jamiya?.name}',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Positioned(
              top: 26,
              left: 6,
              child: Text(
                'Total Amount: $jamiyaAmount',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Positioned(
              top: 46,
              left: 6,
              child: Text(
                'Participants: ${jamiya?.participantsId.length}',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
