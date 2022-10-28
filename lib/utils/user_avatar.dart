import 'package:chatify/constants.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

class UserAvatar extends StatelessWidget {
  final String img;
  UserAvatar({required this.img});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey,
      minRadius: 16,
      maxRadius: 20,
      child: CircleAvatar(
        backgroundImage: AssetImage(img),
        onBackgroundImageError: (e, s) {
          debugPrint('image issue, $e,$s');
        },
        minRadius: 10,
        maxRadius: 18,
        backgroundColor: Colors.white,
      ),
    );
  }
}
