import 'dart:typed_data';

import '../dao/run_dao.dart';
import '../impl/run_dao_impl.dart';
import '../models/run_model.dart';

class RunRepository{
  RunRepository._internal();
  static final RunRepository _runRepository = RunRepository._internal();
  factory RunRepository.instance() => _runRepository;

  final RunDao _runDao = RunDaoImpl.instance();

  Stream<List<RunModel>> getRunList(String email) {
    return _runDao.getRunList(email);
  }

  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      ) {
    return _runDao.insertRun(runModel, mapScreenshot);
  }

  Future<bool> updateRun(String id, Map<String, dynamic> newValues) {
    return _runDao.updateRun(id, newValues);
  }

  Future<bool> deleteRun(String id) {
    return _runDao.deleteRun(id);
  }
}