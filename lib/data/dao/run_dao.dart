import 'dart:typed_data';

import '../repositories/run_repository.dart';

abstract class RunDao {
  Stream<List<RunModel>> getRunList(String email);
  Future<bool> insertRun(
      RunModel runModel,
      Uint8List mapScreenshot,
      );
  Future<bool> updateRun(String id, Map<String, dynamic> newValues);
  Future<bool> deleteRun(String id);
}