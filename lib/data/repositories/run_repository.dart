import 'package:cloud_firestore/cloud_firestore.dart';

class RunModel {
  String id, email, mapScreenshot;
  double distanceRanInMetres, averageSpeed;
  int timeTakenInMilliseconds;

  RunModel({
    required this.id,
    required this.email,
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
    mapScreenshot: mapScreenshot,
    email: document["email"],
    timeTakenInMilliseconds: document["timeTaken"],
    distanceRanInMetres: document["distanceRan"],
    averageSpeed: document["averageSpeed"],
  );
}