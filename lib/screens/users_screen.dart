import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Data/users.dart';
import '../constants.dart';
import '../helpers/datetime.dart' as datetime;
import '../utils/user_bubble.dart';
import 'chat_screen.dart';

final _auth = FirebaseAuth.instance;

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  static const String id = "users_screen";
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with WidgetsBindingObserver {
  bool _isOnline = false;
  final _firestore = FirebaseFirestore.instance;
  final _currUserEmail = _auth.currentUser?.email;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("init state caled");
  }


  void changeStatus() {
    final snapshots = _firestore
        .collection('users')
        .where('email', isEqualTo: _currUserEmail)
        .snapshots();
    QueryDocumentSnapshot<Map<String, dynamic>> currUser;
    snapshots.first.then((value) => {
          currUser = value.docs[0],
          _firestore
              .collection('users')
              .doc(currUser.get("documentID"))
              .update({'isOnline': _isOnline})
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBg = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;
    final isScreen = state == AppLifecycleState.resumed;
    if (!mounted) {

      return;
    }
    isBg || isScreen == true || isClosed == false
        ? setState(() {
            _isOnline = true;
          })
        : setState(() {
            _isOnline = false;
          });

    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;


    }
    changeStatus();
  }

  // List<UserBubble> buildFriendList({required QueryDocumentSnapshot<Object?> message, dynamic friend}){
  //
  //
  //   return senderWidgets;
  // }
  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }

  /*
    Dispose is called when the State object is removed, which is permanent.
    This method is where you should unsubscribe and cancel all animations, streams, etc.
    */
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<UserBubble> senderWidgets = [];
    print(senderWidgets);
    return Scaffold(
        backgroundColor: kUserScreenBg,
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('messages').get(),
          builder: (context, snapshot) {
            List<Text> senders = [];
            List<AppUser> friends = [];
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: kprimaryColor,
                          ),
              );
            }
            if (snapshot.hasData) {
              final messages = snapshot.data?.docs;

              for (var message in messages!) {
                final receiver = message.get('receiver');
                final currUser = _currUserEmail;
                final sender = message.get('sender');

                if (sender == currUser || receiver == currUser) {
                  AppUser friend = AppUser.origin();
                  friend.email = sender == currUser ? receiver : sender;
                  bool isPresent = friends.any((item) => item.email == friend.email);
                  if (!isPresent) {
                    friends.add(friend);
                    QueryDocumentSnapshot<Map<String, dynamic>> user;
                    UserBubble senderWidget;

                    final timestamp = message.get('timestamp');
                    friend.date = datetime.getDatetime(timestamp.seconds);
                    friend.text = message.get('text');
print(friends[0].email);
                  }
                }

              }
            }
            return StreamBuilder<QuerySnapshot>(stream:  _firestore.collection('users')
                .snapshots(),
                builder: (context, users){
              if (snapshot.hasData) {
              final user = users.data?.docs;

              for(var friend in user!){
                try{
                  final result = friends.firstWhere((a) => a.email == (friend.get('email')));

                  if(result != null){
                    UserBubble senderWidget;
                    senderWidget = UserBubble(
                                              username: friend.get('username'),
                                              friend: result.email,
                                              text: result.text,
                                              sentDate: result.date,
                                              //status: user.get('isOnline'),
                                              image: friend.get('image'));
                                          senderWidgets.add(senderWidget);

                  }
                }catch(e){
                  print(e);
                }


                }
              }

              return ListView(
                children: senderWidgets
              );

            });
          },
        )

        // body: StreamBuilder<QuerySnapshot>(
        //     stream: _firestore.collection('messages').snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError) {
        //         return const Text(
        //           "Something went wrong",
        //           style: TextStyle(color: Colors.black),
        //         );
        //       }
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(
        //             backgroundColor: kprimaryColor,
        //           ),
        //         );
        //       }
        //       if (snapshot.hasData) {
        //         final messages = snapshot.data?.docs;
        //         final friends = [];
        //         for (var message in messages!) {
        //           final sender = message.get('sender');
        //           final receiver = message.get('receiver');
        //           final currUser = _currUserEmail;
        //           if (sender == currUser || receiver == currUser) {
        //
        //
        //             final friend = sender == currUser ? receiver : sender;
        //             if (!friends.contains(friend)) {
        //               friends.add(friend);
        //               QueryDocumentSnapshot<Map<String, dynamic>> user;
        //               UserBubble senderWidget;
        //               final timestamp = message.get('timestamp');
        //               var sentDate = datetime.getDatetime(timestamp.seconds);
        //               final snapshots = _firestore
        //                   .collection('users')
        //                   .where('email', isEqualTo: friend)
        //                   .get();
        //               snapshots.then((value) => {
        //                 if (value != null)
        //                   {
        //                     user = value.docs[0],
        //                     senderWidget = UserBubble(
        //                         username: user.get('username'),
        //                         friend: friend,
        //                         text: message.get('text'),
        //                         sentDate: sentDate,
        //                         //status: user.get('isOnline'),
        //                         image: user.get('image')),
        //                     senderWidgets.add(senderWidget),
        //
        //                   }
        //               });
        //             }
        //           }
        //         }
        //
        //       }
        //       return ListView(
        //         children: senderWidgets,
        //       );
        //     })
        );
  }
}

class UserBubble extends StatelessWidget {
  final String friend;
  final String text;
  final String image;
  final String username;
  final String sentDate;
  final bool status = true;
  //required this.status
  UserBubble({
    required this.friend,
    required this.text,
    required this.image,
    required this.username,
    required this.sentDate,
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
        leading: CircleAvatar(
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
        ),
        onTap: () {
          Navigator.pushNamed(context, ChatScreen.id, arguments: {
            'friend': friend,
            'friendUsername': username,
            'friendImage': img
          });
        },
      ),
    );
  }
}
