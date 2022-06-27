import 'dart:typed_data';

import 'package:floor/floor.dart';

@entity
class RunSession{
  @PrimaryKey(autoGenerate: true)
  final int id;
  String? email = null;
  Uint8List? img = null;
  String runSessionTitle = '';
  double timestamp = 0;
  double avgSpeedInKMH = 0;
  int distanceInMeters = 0;
  double timeInMilis = 0;
  int caloriesBurnt = 0;
  int stepsPerSession = 0;

  RunSession(this.id, this.email, this.img, this.runSessionTitle, this.timestamp, this.avgSpeedInKMH, this.distanceInMeters, this.timeInMilis,
      this.caloriesBurnt, this.stepsPerSession);

}