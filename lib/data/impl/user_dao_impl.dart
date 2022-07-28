import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_myfitexercisecompanion/data/dao/user_dao.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../repositories/run_repository.dart';

class UserDaoImpl implements UserDao {
  UserDaoImpl._internal();

  static final UserDaoImpl _userDaoImpl = UserDaoImpl._internal();

  factory UserDaoImpl.instance() => _userDaoImpl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Reference _reference = FirebaseStorage.instance.ref();

  @override
  Future<bool> deleteUser() async {
    try {
      RunRepository.instance()
          .deleteAllRunsOnAcc(_firebaseAuth.currentUser!.email!);
      // QuerySnapshot<Map<String, dynamic>> users = await _firestore
      //     .collection('users')
      //     .where('email', isEqualTo: _firebaseAuth.currentUser?.email)
      //     .get();
      // WriteBatch batch = _firestore.batch();
      // for (var doc in users.docs) {
      //   batch.delete(doc.reference);
      // }
      // await batch.commit();
      WriteBatch batch = _firestore.batch();
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.email!).get().then((querySnapshot) => {
        batch.delete(querySnapshot.reference)
          });
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.email!).collection('messages').get().then((querySnapshot) => {
        querySnapshot.docs.forEach((doc) => {batch.delete(doc.reference)})
      });
      await _firestore.collection('foodTracks').where('email', isEqualTo: _firebaseAuth.currentUser!.email!).get().then((querySnapshot) => {
        querySnapshot.docs.forEach((doc) => {batch.delete(doc.reference)})
      });
      await batch.commit();
      await _firebaseAuth.currentUser?.delete();
      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }

  // const carsList: Observable<firestore.QuerySnapshot> = await this.db.collection('cars', ref => ref.where('categoryId', '==', id)).get();
  // const batch = this.db.firestore.batch();
  // carsList.pipe(
  // mergeMap(cars => cars.docs),
  // map((car: QueryDocumentSnapshot) => batch.delete(car.ref))
  // ).toPromise().then(() => batch.commit());

  @override
  Future<bool> deleteUserImage() async {
    try {
      String email = _firebaseAuth.currentUser!.email!;
      var doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists && doc.data()!.containsKey('profilePic')) {
        await _reference.child(doc['profilePic']).delete();
        await _firestore.collection('users').doc(email).update({
          'profilePic': FieldValue.delete(),
        });
      }
      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<UserDetail?> getUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email)
          .get();
      if (_docChecker(document)) return null;
      return Future.value(UserDetail.fromDocument(
        document,
        await _getProfilePicUrlString(document),
      ));
    } catch (e) {
      print("error ${e.toString()}");
      return null;
    }
  }

  @override
  Stream<UserDetail?> getUserStream() {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.email)
        .snapshots()
        .asyncMap(
      (doc) async {
        if (_docChecker(doc)) return null;
        return UserDetail.fromDocument(
          doc,
          await _getProfilePicUrlString(doc),
        );
      },
    );
  }

  @override
  Future<bool> insertUser(UserDetail user) async {
    try {
      Map<String, dynamic> map = {
        "email": user.email,
        "username": user.username,
        "height": user.height,
        "weight": user.weight,
      };
      await _firestore.collection('users').doc(user.email).set(map);
      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<bool> updateUser(Map<String, dynamic> map, File? selectedImage) async {
    try {
      if (selectedImage != null) {
        String imageFileName = const Uuid().v4();
        await _reference.child(imageFileName).putFile(selectedImage);
        map["profilePic"] = imageFileName;
        var doc = await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.email)
            .get();
        if (doc.data()!.containsKey('profilePic')) {
          _reference.child(doc["profilePic"]).delete();
        }
      }
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email)
          .update(map);
      return Future.value(true);
    } catch (exception) {
      print(exception.toString());
      return Future.value(false);
    }
  }

  bool _docChecker(DocumentSnapshot<Map<String, dynamic>> document) =>
      !document.exists ||
      !document.data()!.containsKey('username') ||
      !document.data()!.containsKey('height') ||
      !document.data()!.containsKey('weight');

  Future<String?> _getProfilePicUrlString(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    String? profilePicUrlString;
    if (!document.data()!.containsKey('profilePic')) {
      return null;
    }
    profilePicUrlString =
        await _reference.child(document['profilePic']).getDownloadURL();
    return profilePicUrlString;
  }

  @override
  Future<DocumentSnapshot?> getCurrentFirestoreUser(email) async {
    var documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(email).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
    return null;
  }
}
