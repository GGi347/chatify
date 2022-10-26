import 'package:chatify/screens/chat_screen.dart';
import 'package:chatify/screens/index_page.dart';
import 'package:chatify/screens/login_screen.dart';
import 'package:chatify/screens/profile_selection_screen.dart';
import 'package:chatify/screens/register_screen.dart';
import 'package:chatify/screens/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chatify",
      theme: ThemeData.dark().copyWith(
        backgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
      routes: {
        IndexPage.id:(context) => IndexPage(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        UserScreen.id: (context) => UserScreen(),
        ProfileSelectionScreen.id: (context) => ProfileSelectionScreen()
      },
    );
  }
}


