import 'package:chatify/constants.dart';
import 'package:chatify/screens/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({Key? key}) : super(key: key);

  static const String id = "profile_selection";
  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  String _username = "";
  int selectedIndex = 0;


  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  List<Widget> getImages(){
    var totalImages = 6;
    List<Widget> images = [];
    for(var i=1; i<=totalImages; i++){
      var imageWidget = GestureDetector(
        onTap: (){
          setState(() {
            selectedIndex = i;
          });
        },
          child: CircleAvatar(
              backgroundColor: selectedIndex == i ? kprimaryColor : Colors.blueGrey,
              minRadius: 26,
              maxRadius: 50,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/avatar/avatar$i.png'),
                onBackgroundImageError: (e, s) {
                  debugPrint('image issue, $e,$s');
                },
                minRadius: 10,
                maxRadius: 44,
                backgroundColor: selectedIndex == i ? kprimaryColor : Colors.white,
              )


          ),
        );


      images.add(imageWidget);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                onChanged: (value){
                  _username = value;
                },
                style: TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Username",
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0
                  ),

                ),
              ),
            ),
            Text("Choose Your Avatar", style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold

            ),),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 28.0,
              clipBehavior: Clip.hardEdge,
              children: getImages(),

            ),
            TextButton(onPressed: (){
                  if(_username == ""){
                    showToast("Username cannot be empty");
                  }
                  if(selectedIndex == 0){
                    showToast("Select an avatar for yourself");
                  }

                  else{
                      final _auth = FirebaseAuth.instance;
                      _auth.currentUser?.updateDisplayName(_username);
                      _auth.currentUser?.updatePhotoURL('images/avatar/avatar$selectedIndex.png');
                      final _firestore = FirebaseFirestore.instance;
                      final users = _firestore.collection('users');

                      users.add({
                        'email': _auth.currentUser?.email,
                        'username': _username,
                        'image': selectedIndex,
                      }).then((docRef) => {
                      users.doc(docRef.id).set({
                        "documentID": docRef.id,

                      })
                      });
                      Navigator.pushNamed(context, UserScreen.id);
                  }
            }, child: Text("Next", style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: kprimaryColor
            ),))
          ],

        ),

      ),
    );
  }
}
