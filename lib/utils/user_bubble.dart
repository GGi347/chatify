import 'package:chatify/constants.dart';
import 'package:chatify/utils/user_avatar.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

class UserBubble extends StatelessWidget {
  final String friend;
  final String text;
  final String image;
  final String username;
  final String sentDate;
  final bool status;

  UserBubble(
      {required this.friend,
      required this.text,
      required this.image,
      required this.username,
      required this.sentDate,
        required this.status,
      });

  @override
  Widget build(BuildContext context) {
    final img = 'images/avatar/avatar$image.png';
    print(this.friend);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        title: Text(username, style: kDarkHeading),
        subtitle: Text(text, style: kLightSubHeading),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: status ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Text(sentDate, style: kLightSubHeading),
          ],
        ),
        leading: UserAvatar(img:img),
        onTap: () {
          Navigator.pushNamed(context, ChatScreen.id, arguments: {
            'friend': friend,
            'friendUsername': username,
            'friendImage': img,
            'status': status
          });
        },
      ),
    );
  }
}
