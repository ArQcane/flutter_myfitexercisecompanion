import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';

import '../models/user.dart';

class FirestoreService {
  AuthService authService = AuthService();

  Future<void> addUser(email, profilePic, username, height, weight) {
    return FirebaseFirestore.instance.collection('users').doc(email).set({
      'userEmail': email,
      'profilePic': profilePic,
      'username': username,
      'height': height,
      'weight': weight
    });
  }

  Future<Object?> getCurrentFirestoreUser(email) async {
    var documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(email).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
    return null;
  }

  Future<UserDetail> getCurrentFirestoreUserData(email) async{
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(email).get();
      Map<String, dynamic>? data = docSnapshot.data();

      var currentUser = UserDetail.fromMap(data!);
      return currentUser;
  }

  updateCurrentFirestoreUser(
      email, profilePic, username, height, weight) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set({
          'userEmail': email,
          'profilePic': profilePic,
          'username': username,
          'height': height,
          'weight': weight
        })
        .then((value) => print('User Updated'))
        .catchError((onError) => print('Failed to update user: $onError'));
  }

  Future<void> deleteCurrentFirestoreUser(email) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((onError) => print('Failed to delete user: $onError'));
  }
}
