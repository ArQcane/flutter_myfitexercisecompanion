import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/run_repository.dart';

import '../dao/run_dao.dart';
import '../models/run_model.dart';

class RunDaoImpl implements RunDao {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _reference = FirebaseStorage.instance.ref();

  RunDaoImpl._internal();

  static final RunDaoImpl _instance = RunDaoImpl._internal();

  factory RunDaoImpl.instance() {
    return _instance;
  }

  @override
  Future<bool> deleteRun(String id) {
    // TODO: implement deleteRun
    throw UnimplementedError();
  }

  @override
  Stream<List<RunModel>> getRunList(String email) {
    return _firestore
        .collection("runs")
        .where('email', isEqualTo: email)
        .orderBy('timeStarted')
        .snapshots()
        .asyncMap(
          (snapshot) async => await _convertToList(snapshot),
    );
  }

  Future<List<RunModel>> _convertToList(
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      ) async {
    List<DocumentSnapshot<Map<String, dynamic>>> docList = querySnapshot.docs;
    List<RunModel> runList = [];
    for (var document in docList) {
      runList.add(
        RunModel.fromMap(
          document,
          await _getDownloadUrl(document["mapScreenshot"]),
        ),
      );
    }
    return runList;
  }
  Future<String> _getDownloadUrl(String child) async {
    return await _reference.child(child).getDownloadURL();
  }

  @override
  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      ) async {
    try {
      await _reference.child(runModel.mapScreenshot).putData(mapScreenshot);
      await _firestore.collection('runs').doc().set({
        'email': runModel.email,
        'mapScreenshot': runModel.mapScreenshot,
        'timeTaken': runModel.timeTakenInMilliseconds,
        'distanceRan': runModel.distanceRanInMetres,
        'averageSpeed': runModel.averageSpeed,
      });
      return true;
    } catch (e) {
      print((e as FirebaseException).message.toString());
      return false;
    }
  }


  @override
  Future<bool> updateRun(String id, Map<String, dynamic> newValues) {
    // TODO: implement updateRun
    throw UnimplementedError();
  }
}