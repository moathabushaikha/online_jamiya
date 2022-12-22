import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/models/models.dart';

class JamiyaThumbnail extends StatelessWidget {
  final Jamiya? jamiya;

  const JamiyaThumbnail({Key? key, required this.jamiya}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var x = jamiya?.participantsId.length as int;
    var y = jamiya?.shareAmount as int;
    int jamiyaAmount = x * y;
    DateTime? startDate = jamiya?.startingDate;
    String formattedSDate = DateFormat('dd/MM/yyyy').format(startDate!);
    String formattedEDate = DateFormat('dd/MM/yyyy').format(jamiya!.endingDate);
    return Container(
      padding: const EdgeInsets.only(left: 8,right: 5),
      decoration: BoxDecoration(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Jamiya Name: ${jamiya?.name}',
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            'Total Amount: $jamiyaAmount',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            'Participants: ${jamiya?.participantsId.length}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            'Starting: $formattedSDate',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            'Ending: $formattedEDate',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
