import 'package:cloud_firestore/cloud_firestore.dart';

class RunModel{
  String id, email, runTitle, mapScreenshot, darkMapScreenshot;
  double distanceRanInMetres, averageSpeed;
  int timeTakenInMilliseconds, timestamp;

  RunModel({
    required this.id,
    required this.email,
    required this.runTitle,
    required this.mapScreenshot,
    required this.darkMapScreenshot,
    required this.timeTakenInMilliseconds,
    required this.distanceRanInMetres,
    required this.averageSpeed,
    required this.timestamp,
  });

  RunModel.fromMap(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) : this(
    id: document.id,
    email: document["email"],
    runTitle: document['runTitle'],
    mapScreenshot: document['mapScreenshot'],
    darkMapScreenshot: document['darkMapScreenshot'],
    timeTakenInMilliseconds: document["timeTaken"],
    distanceRanInMetres: document["distanceRan"],
    averageSpeed: document["averageSpeed"],
    timestamp: document["timestamp"],
  );
}