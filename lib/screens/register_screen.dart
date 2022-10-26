import 'package:chatify/screens/chat_screen.dart';
import 'package:chatify/screens/index_page.dart';
import 'package:chatify/screens/profile_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../utils/rounded_button.dart';
import '../utils/rounded_textfield.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "register_page";
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "";
  String password = "";
  bool showSpinner = false;
  
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 120.0, horizontal: 24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 80.0,
                      child: Image.asset('images/chatify.png'),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),


                  RoundedTextField(hint: "Enter your email",onChanged: (value){
                    email = value;
                  }, inputType:  TextInputType.emailAddress, obscureText: false),
                  SizedBox(height: 8.0,),
                  RoundedTextField(hint: "Enter your Password",onChanged: (value){
                    password = value;
                  }, inputType:  TextInputType.text, obscureText: true),
                  SizedBox(height: 8.0,),
                  RoundedTextField(hint: "Re-enter password",onChanged: (value){
                    print(value);
                  },inputType:  TextInputType.text, obscureText: true),
                  SizedBox(height: 30.0,),
                  RoundedButton(color: kprimaryColor, onPressed: () async{
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if(user != null){

                        Navigator.pushNamed(context, ProfileSelectionScreen.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    }catch(e){
                      print(e);
                    }

                  }, title:"Register"),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
