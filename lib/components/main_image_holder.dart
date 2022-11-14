import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';

class MainImageHolder extends StatefulWidget {
  final User? cUser;

  const MainImageHolder({Key? key, required this.cUser}) : super(key: key);

  @override
  State<MainImageHolder> createState() => _MainImageHolderState();
}

class _MainImageHolderState extends State<MainImageHolder> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      // Drawing Image holder shape
      children: [
        Consumer2<ProfileManager, AppStateManager>(
          builder: (context, profileManager, appStateManager, child) {
            return Container(
              width: double.infinity,
              height: 205,
              color: profileManager.darkMode
                  ?  JamiyaTheme.dark().backgroundColor
                  : JamiyaTheme.light().backgroundColor,
            );
          },
        ),
        Positioned(
          right: 10,
          child: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2.0, color: Colors.white),
                  //TODO change Load Image from server
                  image: const DecorationImage(
                      image: AssetImage(
                    'assets/profile_images/profile_image.png',
                  ))),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome'),
              Text(
                '${widget.cUser?.firstName} ${widget.cUser?.lastName} '
                    '${widget.cUser?.darkMode}',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Icon(Icons.location_on),
                  // TODO add current location
                  Text('current locations'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
