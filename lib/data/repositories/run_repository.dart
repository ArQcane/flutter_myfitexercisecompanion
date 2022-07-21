import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../dao/run_dao.dart';
import '../impl/run_dao_impl.dart';
import '../models/run_model.dart';

class RunRepository{
  RunRepository._internal();
  static final RunRepository _runRepository = RunRepository._internal();
  factory RunRepository.instance() => _runRepository;

  final RunDao _runDao = RunDaoImpl.instance();
  final Reference _reference = FirebaseStorage.instance.ref();

  Stream<List<RunModel>> getRunList(String email) {
    return _runDao.getRunList(email);
  }

  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      ) {
    return _runDao.insertRun(runModel, mapScreenshot);
  }

  Future<bool> updateRun(List<String> idList, String newTitle) {
    return _runDao.updateRun(idList, newTitle);
  }

  Future<bool> deleteRun(List<String> idList) {
    return _runDao.deleteRun(idList);
  }

  Future<String> getImageURL(String child){
    return _reference.child(child).getDownloadURL();
  }
  Future<bool> deleteAllRunsOnAcc(String email) {
    return _runDao.deleteAllRunsOnAcc(email);
  }

  Future<bool> undoDelete(RunModel runModel){
    return _runDao.undoDelete(runModel);
  }
}