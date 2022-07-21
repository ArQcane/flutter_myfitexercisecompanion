import 'dart:typed_data';

import '../models/run_model.dart';

abstract class RunDao {
  Stream<List<RunModel>> getRunList(String email);
  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      );
  Future<bool> updateRun(List<String> idList, String newTitle);
  Future<bool> deleteRun(List<String> idList);
  Future<bool> deleteAllRunsOnAcc(String email);
  Future<bool> undoDelete(
      RunModel runModel,
      );
}