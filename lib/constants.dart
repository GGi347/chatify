import 'package:flutter/material.dart';

const kprimaryColor = Color(0xFF57A6BF);
const kUserScreenBg = Color(0xFFFAFAFA);


const kSendButtonTextStyle = TextStyle(
  color: kprimaryColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kLightSubHeading = TextStyle(
  color: Colors.black54,
  fontSize: 12.0,
);

const kDarkHeading =  TextStyle(
    color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.grey),
  border: InputBorder.none,
);
