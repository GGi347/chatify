import 'package:chatify/constants.dart';
import 'package:chatify/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Data/users.dart';

class CustomSearchDelegate extends SearchDelegate{

  List<AppUser> searchTerms = [];

  CustomSearchDelegate(){
    searchTerms = getAllUsers();
  }

  List<AppUser> getAllUsers(){
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final currUser = auth.currentUser;
    List<AppUser> users = [];
    firestore.collection('users').get().then((value) => value.docs.forEach((element) {
      if(element.get('email') != currUser?.email){
        AppUser user = AppUser.origin();
        user.email = element.get('email');
        user.username = element.get('username');
        final image = element.get('image');
        user.image = 'images/avatar/avatar$image.png';
        user.isOnline = element.get('isOnline');
        users.add(user);
      }

    }));
  return users;
  }



  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];

  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<AppUser> matchQuery = [];
    for (var user in searchTerms) {
      if (user.email.toLowerCase().contains(query.toLowerCase()) || user.username.toLowerCase().contains(query.toLowerCase()) ) {
        matchQuery.add(user);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        print(matchQuery.isNotEmpty);
        return matchQuery.isNotEmpty ? ListTile(
          title: Text(result.username),
            onTap: (){
              Navigator.pushNamed(context, ChatScreen.id, arguments: {
                'friend': result.email,
                'friendUsername': result.username,
                'friendImage': result.image,
                'status': result.isOnline
              });
            }
        ) :const  Center(child: Text("Search result not found", style: kDarkHeading,),);
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<AppUser> matchQuery = [];
    for (var user in searchTerms) {
      if (user.email.toLowerCase().contains(query.toLowerCase()) || user.username.toLowerCase().contains(query.toLowerCase()) ) {
        matchQuery.add(user);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        print(matchQuery.isNotEmpty);

        return matchQuery.isNotEmpty ? ListTile(
          title: Text(result.username),
          onTap: (){
            Navigator.pushNamed(context, ChatScreen.id, arguments: {
              'friend': result.email,
              'friendUsername': result.username,
              'friendImage': result.image,
              'status': result.isOnline
            });
          }
        ) : const  Center(child: Text("Search result not found", style: kDarkHeading,),);

      },

    );

  }
  
}