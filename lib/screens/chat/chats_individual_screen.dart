import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_model.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/auth_repository.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/user_repository.dart';
import 'package:flutter_myfitexercisecompanion/screens/chat/widget/message_textfield.dart';
import 'package:flutter_myfitexercisecompanion/screens/chat/widget/single_message.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:shimmer/shimmer.dart';

class ChatsIndividualScreen extends StatefulWidget {
  final UserDetail currentUser;
  final String friendEmail;
  final String friendName;
  final String? friendImage;

  ChatsIndividualScreen({
    required this.currentUser,
    required this.friendEmail,
    required this.friendName,
    required this.friendImage,
  });

  @override
  State<ChatsIndividualScreen> createState() => _ChatsIndividualScreenState();
}

class _ChatsIndividualScreenState extends State<ChatsIndividualScreen> {


  Color get _baseColor {
    return Theme
        .of(context)
        .brightness == Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[300]!;
  }

  Color get _highlightColor {
    return Theme
        .of(context)
        .brightness == Brightness.dark
        ? Colors.grey[100]!
        : Colors.grey[50]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: FutureBuilder<String?>(
            future: FirebaseStorage.instance
                .ref()
                .child(widget.friendImage ?? "")
                .getDownloadURL(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Shimmer.fromColors(
                      baseColor: _baseColor,
                      highlightColor: _highlightColor,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: LinearProgressIndicator(),
                            ),
                            TextSpan(
                              text: "Loading",
                            ),
                          ],
                        ),
                      )),
                );
              }
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: snapshot.hasData ? Image.network(
                      snapshot.data!,
                      height: 35,
                    ) : CircleAvatar(child: Icon(Icons.person)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.friendName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              );
            }),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .background,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(AuthRepository().getCurrentUser()!.email)
                      .collection('messages')
                      .doc(widget.friendEmail)
                      .collection('chats')
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.docs.length < 1){
                        return Center(
                          child: Text("Say Hi!"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            bool isMe = snapshot.data.docs[index]['senderId'] == widget.currentUser.username;
                            return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe);
                          });
                    }
                    return LoadingCircle();
                  },
                ),
              )),
          MessageTextField(
            widget.currentUser.username,
            widget.friendEmail,
          )
        ],
      ),
    );
  }
}
