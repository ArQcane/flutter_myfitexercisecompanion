import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String email;
  String? profilePic;
  String username;
  double weight;
  double height;

  UserDetail({
    required this.email,
    required this.profilePic,
    required this.username,
    required this.weight,
    required this.height
  });

  UserDetail.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document,
      String? profilePic,
      ) : this (
        email:  document.id,
        profilePic: profilePic,
        username: document['username'] ?? '',
        weight: document['weight'] ?? 0.0,
        height: document['height'] ?? 0.0,
  );
}