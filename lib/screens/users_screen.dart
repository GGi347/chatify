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
  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }

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
        appBar: AppBar(
          title: const Text('CHATIFY', style: kAppBarHeading,),
          scrolledUnderElevation: 6.0,
          shadowColor: Theme.of(context).colorScheme.shadow,

          leading:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
            child: Image.asset('images/chatify.png',),
          ),
          backgroundColor: kprimaryColor,
        ),
        backgroundColor: kUserScreenBg,
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.black),
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
              return FutureBuilder<QuerySnapshot>(future:  _firestore.collection('users')
                  .get(),
                  builder: (context, users){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: kprimaryColor,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text(
                        "Something went wrong",
                        style: TextStyle(color: Colors.black),
                      );
                    }
                if (snapshot.hasData) {
                final user = users.data?.docs;
                if(user == null){
                  return const Center(child:  Text("Please Wait", style: kLightSubHeading,));
                }
                for(var friend in user){
                  try{
                    final result = friends.firstWhere((a) => a.email == (friend.get('email')));

                    UserBubble senderWidget;
                    senderWidget = UserBubble(
                                              username: friend.get('username'),
                                              friend: result.email,
                                              text: result.text,
                                              sentDate: result.date,
                                              status: friend.get('isOnline'),
                                              image: friend.get('image'));
                                          senderWidgets.add(senderWidget);
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
          ),
        )

        );
  }
}

