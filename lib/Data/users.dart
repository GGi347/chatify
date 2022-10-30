import 'package:flutter/material.dart';

class AppUser{
  AppUser( this.email,this.username,  this.text,  this.image,  this.date, this.isOnline, this.timestamp);

  AppUser.origin() : this("", "", "", "", "", false, 0);
  String email ;
  String username;
   String image;
 String date;
 String text;
 bool isOnline;
  int timestamp;



}

