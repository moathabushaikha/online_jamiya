import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'dart:io';

class MainImageHolder extends StatefulWidget {
  final User? currentUser;

  const MainImageHolder({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<MainImageHolder> createState() => _MainImageHolderState();
}

class _MainImageHolderState extends State<MainImageHolder> {
  File? fileImage;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        fileImage = imageTemp;
        widget.currentUser?.imgUrl = image.path;
        Provider.of<AppStateManager>(context, listen: false).updateUser(widget.currentUser!);
        Provider.of<AppCache>(context,listen: false).setCurrentUser(widget.currentUser!);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Drawing Image holder shape
      children: [
        Consumer<AppStateManager>(
          builder: (context, appStateManager, child) {
            return Container(
                width: double.infinity, height: 205,);
          },
        ),
        Positioned(
          right: 10,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              width: 200,
              height: 180,
              margin: const EdgeInsets.only(top: 10,bottom: 10),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover,
                  image: widget.currentUser?.imgUrl != ""
                      ? FileImage(widget.currentUser != null
                          ? File(widget.currentUser?.imgUrl as String)
                          : File(''))
                      : const AssetImage(
                          'assets/profile_images/profile_image.png',
                        ) as ImageProvider,
                  scale: 2.0,
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
              Text('Welcome', style:Theme.of(context).textTheme.headline3),
              Text(
                '${widget.currentUser?.firstName} ${widget.currentUser?.lastName}',
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
