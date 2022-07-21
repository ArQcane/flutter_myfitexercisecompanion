import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  Future<void> addUser(email, profilePic, username, height, weight) {
    return FirebaseFirestore.instance.collection('users').doc(email).set({
      'userEmail': email,
      'profilePic': profilePic,
      'username': username,
      'height': height,
      'weight': weight
    });
  }


  Future<void> updateCurrentFirestoreUser(
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

  Future deleteLoggedInUser(uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }
}
