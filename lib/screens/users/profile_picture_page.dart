import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicturePage extends StatelessWidget {
  const ProfilePicturePage(this.image, {super.key});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'profile_pic',
            child: InteractiveViewer(
              child: Image.network(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}