import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/Others/global.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/auth_repository.dart';
import 'package:flutter_myfitexercisecompanion/screens/chat/chats_individual_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/chat/search_user_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';

import '../../data/models/user_model.dart';

class ChatsScreen extends StatefulWidget {
  UserDetail user;

  ChatsScreen(this.user);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Color get _baseColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[300]!;
  }

  Color get _highlightColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[100]!
        : Colors.grey[50]!;
  }

  String? profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Chats'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(AuthRepository().getCurrentUser()!.email)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("No Chats Available !"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendEmail = snapshot.data.docs[index].id;
                    friendId.add(snapshot.data.docs[index].id);
                    print("working: $friendId");
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendEmail)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if(asyncSnapshot.connectionState == ConnectionState.waiting){
                          return LoadingCircle();
                        }
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          Map<String, dynamic> friendMap = asyncSnapshot.data.data();
                          return FutureBuilder<String?>(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child(friendMap.containsKey('profilePic') ? friend['profilePic'] : "")
                                  .getDownloadURL(),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return LoadingCircle(); //to add shimmer effect here
                                }
                                return ListTile(
                                  leading: ClipRRect(
                                    child: snapshot.hasData ? Image.network(snapshot.data!) : CircleAvatar(child: Icon(Icons.person)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  title: Text(friend['username']),
                                  subtitle: Container(
                                    child: Text(
                                      "$lastMsg",
                                      style: TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatsIndividualScreen(
                                                    currentUser: widget.user,
                                                    friendName:
                                                        friend['username'],
                                                    friendEmail:
                                                        friend['email'],
                                                    friendImage:friendMap.containsKey('profilePic') ? friend['profilePic'] : "")));
                                  },
                                );
                              });
                        }
                        return LinearProgressIndicator();
                      },
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.search,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchUserScreen(widget.user)));
        },
      ),
    );
  }
}
