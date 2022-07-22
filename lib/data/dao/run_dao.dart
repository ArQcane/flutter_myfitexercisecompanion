import 'dart:typed_data';

import '../models/run_model.dart';

abstract class RunDao {
  Stream<List<RunModel>> getRunList(String email);
  Stream<List<RunModel>> getLatestRun(String email);
  Stream<List<RunModel>> sortRunsByTypeList(String email, String sort);
  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      Uint8List darkMapScreenshot,
      );
  Future<bool> updateRun(List<String> idList, String newTitle);
  Future<bool> deleteRun(List<String> idList);
  Future<bool> deleteAllRunsOnAcc(String email);
  Future<bool> undoDelete(
      RunModel runModel,
      );
}