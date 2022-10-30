import 'package:chatify/constants.dart';
import 'package:flutter/material.dart';

class MessageBubbles extends StatelessWidget {
  final String text;
  final String friend;
  final String? friendImage;
  final bool isMe;
  final String sentDate;

  MessageBubbles({required this.text, required this.friend, required this.isMe,  this.friendImage, required this.sentDate});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(sentDate, style: kLightSubHeading,),
            Text(friend, style: TextStyle(
                color: Colors.black38,
                fontSize: 12.0
            ),),

            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                elevation: 5.0,
                borderRadius: isMe ? const BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(0.0)) :
                const BorderRadius.only(topLeft: Radius.circular(0.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                color: isMe ? kprimaryColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(text, style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0
                  ),),
                ),
              ),
            ),

          ],
        )
    );
  }
}

