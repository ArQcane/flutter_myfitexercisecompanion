import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';


class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  MessageTextField(this.currentId,this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
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

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                labelText:"Type your Message",
                fillColor: _highlightColor,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25)
                )
            ),
          )),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance.collection('users').doc(AuthRepository().getCurrentUser()!.email).collection('messages').doc(widget.friendId).collection('chats').add({
                "senderId":widget.currentId,
                "receiverId":widget.friendId,
                "message":message,
                "type":"text",
                "date":DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance.collection('users').doc(AuthRepository().getCurrentUser()!.email).collection('messages').doc(widget.friendId).set({
                  'last_msg':message,
                });
              });

              await FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(AuthRepository().getCurrentUser()!.email).collection("chats").add({
                "senderId":widget.currentId,
                "receiverId":widget.friendId,
                "message":message,
                "type":"text",
                "date":DateTime.now(),

              }).then((value){
                FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(AuthRepository().getCurrentUser()!.email).set({
                  "last_msg":message
                });
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(Icons.send,color: Colors.white,),
            ),
          )
        ],
      ),

    );
  }
}