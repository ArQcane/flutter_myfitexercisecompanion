import 'package:floor/floor.dart';
import 'package:flutter_myfitexercisecompanion/models/run_session.dart';

@dao
abstract class RunSessionDao{
  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY timestamp DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedByDate(String email);

  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY timeInMilis DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedByTimeInMilis(String email);

  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY caloriesBurnt DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedByCaloriesBurnt(String email);

  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY avgSpeedInKMH DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedByAvgSpeed(String email);

  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY distanceInMeters DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedByDistance(String email);

  @Query("SELECT * FROM runsession WHERE email = :email ORDER BY stepsPerSession DESC")
  Stream<List<RunSession>> getAllRunSessionsSortedBySteps(String email);

  @insert
  Future<void> insertRunSession(RunSession runSession);

  @delete
  Future<void> deleteRunSession(RunSession runSession);
}