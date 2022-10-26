import 'package:flutter/material.dart';


  String getDatetime(int seconds){
    final now = DateTime.now();
    String sentDate = "";
    var messageDate = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    var diff = now.difference(messageDate);
    if(diff.inDays == 0){
      if(diff.inHours != 0){
        sentDate = '${diff.inHours}:${diff.inMinutes}';
      }
      else if(diff.inMinutes != 0){
        sentDate = '${diff.inMinutes} minutes ago';
      }
      else if(diff.inSeconds != 0){
        sentDate =  '${diff.inSeconds} seconds ago';
      }
      else{
        sentDate = "Now";
      }
    }
    else{
      sentDate = "${messageDate.day}/${messageDate.month}/${messageDate.year}";
    }
    return sentDate;

  }
