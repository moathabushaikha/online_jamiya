import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MainImageHolder extends StatefulWidget {
  final User? cUser;

  const MainImageHolder({Key? key, required this.cUser}) : super(key: key);

  @override
  State<MainImageHolder> createState() => _MainImageHolderState();
}

class _MainImageHolderState extends State<MainImageHolder> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
                  ? JamiyaTheme.dark().backgroundColor
                  : JamiyaTheme.light().backgroundColor,
            );
          },
        ),
        Positioned(
          right: 10,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? FileImage(image!)
                      : const AssetImage('assets/profile_images/profile_image.png') as ImageProvider,
                ),
                shape: BoxShape.circle,
                border: Border.all(width: 2.0, color: Colors.white),
              ),
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
                '${widget.cUser?.firstName} ${widget.cUser?.lastName}',
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
