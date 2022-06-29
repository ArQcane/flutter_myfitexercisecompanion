import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';

import '../models/user.dart';

class FirestoreService{
  AuthService authService = AuthService();

  Future<void> addUser(email, username, weight, height) {
    return FirebaseFirestore.instance.collection('users').doc(email).set({
      'userEmail': email,
      'username': username,
      'weight': weight,
      'height': height
    });
  }

  Future<Object?> getCurrentFirestoreUser(email) async{
    var documentSnapshot = await FirebaseFirestore.instance.collection("users")
        .doc(email)
        .get();
    if(documentSnapshot.exists){
      return documentSnapshot;
    }
    return null;
  }

  Future<void> updateCurrentFirestoreUser(email, username, weight, height){
    return FirebaseFirestore.instance.collection('users').doc(email).update(
        {'userEmail': email,
          'username': username,
          'weight': weight,
          'height': height
        }).then((value) => print('User Updated'))
        .catchError((onError) => print('Failed to update user: $onError'));
  }

  Future<void> deleteCurrentFirestoreUser(email){
    return FirebaseFirestore.instance.collection('users').doc(email)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((onError) => print('Failed to delete user: $onError'));
  }
}