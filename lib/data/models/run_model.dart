import 'package:cloud_firestore/cloud_firestore.dart';

class RunModel{
  String id, email, runTitle, mapScreenshot;
  double distanceRanInMetres, averageSpeed;
  int timeTakenInMilliseconds;

  RunModel({
    required this.id,
    required this.email,
    required this.runTitle,
    required this.mapScreenshot,
    required this.timeTakenInMilliseconds,
    required this.distanceRanInMetres,
    required this.averageSpeed,
  });

  RunModel.fromMap(
      DocumentSnapshot<Map<String, dynamic>> document,
      String mapScreenshot,
      ) : this(
    id: document.id,
    email: document["email"],
    runTitle: document['runTitle'],
    mapScreenshot: mapScreenshot,
    timeTakenInMilliseconds: document["timeTaken"],
    distanceRanInMetres: document["distanceRan"],
    averageSpeed: document["averageSpeed"],
  );
}