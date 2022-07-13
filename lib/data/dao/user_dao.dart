import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_detail.dart';

abstract class UserDao{
  Future<UserDetail?> getUser();
  Stream<UserDetail?> getUserStream();
  Future<bool> insertUser(UserDetail user);
  Future<bool> updateUser(Map<String, dynamic> map, File? selectedImage);
  Future<bool> deleteUser();
  Future<bool> deleteUserImage();
  Future<DocumentSnapshot?> getCurrentFirestoreUser(email);
}