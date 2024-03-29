
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/food_track_task.dart';
import '../data/repositories/auth_repository.dart';

class FoodDatabaseService {
  final String uid;
  final DateTime currentDate;
  FoodDatabaseService({required this.uid, required this.currentDate});

  final DateTime today =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2020, 09, 07);
  // collection reference
  final CollectionReference foodTrackCollection =
  FirebaseFirestore.instance.collection('foodTracks');

  Future addFoodTrackEntry(FoodTrackTask food) async {
    return await foodTrackCollection
        .doc(food.createdOn.millisecondsSinceEpoch.toString())
        .set({
      'food_name': food.food_name,
      'calories': food.calories,
      'carbs': food.carbs,
      'fat': food.fat,
      'protein': food.protein,
      'mealTime': food.mealTime,
      'createdOn': food.createdOn,
      'grams': food.grams,
      'email': AuthRepository().getCurrentUser()!.email,
    });
  }

  Future deleteFoodTrackEntry(FoodTrackTask deleteEntry) async {
    print(deleteEntry.toString());
    return await foodTrackCollection
        .doc(deleteEntry.createdOn.millisecondsSinceEpoch.toString())
        .delete();
  }

  List<FoodTrackTask> _scanListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodTrackTask(
        id: doc.id,
        food_name: doc['food_name'] ?? '',
        calories: doc['calories'] ?? 0,
        carbs: doc['carbs'] ?? 0,
        fat: doc['fat'] ?? 0,
        protein: doc['protein'] ?? 0,
        mealTime: doc['mealTime'] ?? "",
        createdOn: doc['createdOn'].toDate() ?? DateTime.now(),
        grams: doc['grams'] ?? 0,
        email: doc['email'] ?? AuthRepository().getCurrentUser()!.email,
      );
    }).toList();
  }

  Stream<List<FoodTrackTask>> get foodTracks {
    return foodTrackCollection.where("email", isEqualTo: AuthRepository().getCurrentUser()!.email).snapshots().map(_scanListFromSnapshot);
  }

  Future<List<dynamic>> getAllFoodTrackData() async {
    QuerySnapshot snapshot = await foodTrackCollection.where('email', isEqualTo: AuthRepository().getCurrentUser()!.email).get();
    List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
    return result;
  }

  Future<String> getFoodTrackData(String uid) async {
    DocumentSnapshot snapshot = await foodTrackCollection.doc(uid).get();
    return snapshot.toString();
  }
}
