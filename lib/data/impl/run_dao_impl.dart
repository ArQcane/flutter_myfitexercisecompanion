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
  Future<bool> deleteRun(List<String> idList) async {
    try {
      WriteBatch batch = _firestore.batch();
      for (String id in idList) {
        DocumentSnapshot<Map<String, dynamic>> document =
            await _firestore.collection('runs').doc(id).get();
        batch.delete(document.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print(e);
      if (e is! FirebaseException) return false;
      print(e.message.toString());
      return false;
    }
  }

  @override
  Stream<List<RunModel>> getRunList(String email) {
    return _firestore
        .collection("runs")
        .where('email', isEqualTo: email)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((document) => RunModel.fromMap(document))
          .toList(),
    );
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
        'runTitle': runModel.runTitle,
        'timeTaken': runModel.timeTakenInMilliseconds,
        'distanceRan': runModel.distanceRanInMetres,
        'averageSpeed': runModel.averageSpeed,
        'timestamp' : runModel.timestamp
      });
      return true;
    } catch (e) {
      print((e as FirebaseException).message.toString());
      return false;
    }
  }


  @override
  Future<bool> updateRun(List<String> idList, String newTitle) async {
    try{
      for (String id in idList) {
        await _firestore.collection('runs').doc(id).update({
          'runTitle': newTitle
        });
      }
      return true;
    } catch(e){
      print((e as FirebaseException).message.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteAllRunsOnAcc(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> allRuns = await _firestore
          .collection('runs')
          .where('email', isEqualTo: email)
          .get();
      WriteBatch batch = _firestore.batch();
      for (var doc in allRuns.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> undoDelete(RunModel runModel) async {
    try{
      await _firestore.collection('runs').doc().set({
        'email': runModel.email,
        'mapScreenshot': runModel.mapScreenshot,
        'runTitle': runModel.runTitle,
        'timeTaken': runModel.timeTakenInMilliseconds,
        'distanceRan': runModel.distanceRanInMetres,
        'averageSpeed': runModel.averageSpeed,
        'timestamp' : runModel.timestamp
      });
      return true;
    } catch (e) {
      print((e as FirebaseException).message.toString());
      return false;
    }
  }
}