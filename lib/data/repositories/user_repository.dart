import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_model.dart';

import '../dao/user_dao.dart';
import '../impl/user_dao_impl.dart';

class UserRepository{
  UserRepository._internal();
  static final UserRepository _userRepository = UserRepository._internal();
  factory UserRepository.instance() => _userRepository;

  final UserDao _userDao = UserDaoImpl.instance();

  Future<UserDetail?> getUser() => _userDao.getUser();
  Stream<UserDetail?> getUserStream() => _userDao.getUserStream();
  Future<bool> insertUser(UserDetail user) => _userDao.insertUser(user);
  Future<bool> updateUser({
    required Map<String, dynamic> map,
    File? profilePic,
  }) =>
      _userDao.updateUser(
        map,
        profilePic,
      );
  Future<bool> deleteUser() => _userDao.deleteUser();
  Future<bool> deleteUserImage() => _userDao.deleteUserImage();

  Future<DocumentSnapshot?> getCurrentFirestoreUser(email)=> _userDao.getCurrentFirestoreUser(email);
}