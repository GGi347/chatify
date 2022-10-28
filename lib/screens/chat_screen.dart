import 'package:chatify/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/message_bubbles.dart';
import '../utils/user_avatar.dart';

class ChatScreen extends StatefulWidget {
  static const id = "chat_screen";


  //ChatScreen({required this.friend, required this.friendImage, required this.friendUsername});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  User? firebaseUser;
  String text = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      print(user?.email);
      if (user != null) {
        firebaseUser = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void MakeWidget({text, messageSender, messageReceiver}){


  }

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    final String friend = arguments["friend"];
    final String friendUsername = arguments["friendUsername"] ?? "User";
    final String friendImage = arguments["friendImage"];
    final bool friendStatus = arguments["status"];
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Row(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAvatar(img:friendImage),
            const SizedBox(width: 6.0,),
            Text(friendUsername , style: kAppBarHeading,),
            const SizedBox(width: 4.0,),
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: friendStatus ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        scrolledUnderElevation: 6.0,
        shadowColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        StreamBuilder<QuerySnapshot>(stream: _firestore.collection('messages').snapshots(),
            builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("Something went wrong", style: TextStyle(color: Colors.black),);
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kprimaryColor,
              ),
            );
          }
          if(snapshot.hasData){
            final messages = snapshot.data?.docs.reversed;
            List<MessageBubbles> messagebubbles = [];
            for(var message in messages!){

              final messageSender = message.get('sender');
              final messageReceiver = message.get('receiver');
              if((messageSender == firebaseUser?.email || messageSender == friend) && (messageReceiver == friend || messageReceiver == firebaseUser?.email)){
                final messageText = message.get('text');
                bool isMe = messageSender == firebaseUser?.email;
                String? myImg  =  _auth.currentUser?.photoURL;

                final messageWidget = MessageBubbles(text: messageText, friend: isMe ? "You" : friendUsername, friendImage: isMe ? myImg : friendImage, isMe: isMe);
                messagebubbles.add(messageWidget);
              }


            }

            return Expanded(
              child: ListView(
                reverse: true,
                children: messagebubbles,
              ),
            );
          }
          return Text("No data", style: TextStyle(color: Colors.black));

            }),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: kMessageTextFieldDecoration,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value){
                    text = value;
                  },
                ),
              ),
              MaterialButton(
                onPressed: () async{
                  messageController.clear();
                  _firestore.collection('messages').add({
                    'text': text,
                    'sender': firebaseUser?.email,
                    'receiver': friend,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                },
                child: const Text(
                  "Send",
                  style: kSendButtonTextStyle,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
