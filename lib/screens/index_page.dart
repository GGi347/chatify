import 'package:chatify/constants.dart';
import 'package:chatify/screens/login_screen.dart';
import 'package:chatify/screens/register_screen.dart';
import 'package:chatify/utils/rounded_button.dart';
import 'package:flutter/material.dart';


class IndexPage extends StatefulWidget {
  static const String id = "index_page";

  IndexPage({Key? key}) : super(key: key);
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 120.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text("Chatify", style: TextStyle(
                fontSize: 40.0,
                color: kprimaryColor,
              ),),
            ),
            SizedBox(height: 20.0,),
            Hero(
              tag: 'logo',
              child: Container(
                height: 40.0,
                child: Image.asset('images/chatify.png'),
              ),
            ),
            SizedBox(
              height: 120.0,
            ),
            RoundedButton(color: kprimaryColor, onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            }, title:"Log In"),

            RoundedButton(color: kprimaryColor, onPressed: (){
              Navigator.pushNamed(context, RegisterScreen.id);
            }, title:"Register"),
          ],
        ),
      ),
    );
  }
}
