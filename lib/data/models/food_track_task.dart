import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class FoodTrackTask {
  String id;
  String food_name;
  num calories;
  num carbs;
  num fat;
  num protein;
  String mealTime;
  DateTime createdOn;
  num grams;
  String email;

  FoodTrackTask({
    required this.food_name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.mealTime,
    required this.createdOn,
    required this.grams,
    required this.email,
    String? id,
  }) : this.id = id ?? Uuid().v4();

  factory FoodTrackTask.fromSnapshot(DataSnapshot snap) => FoodTrackTask(
      food_name: snap.child('food_name').value as String,
      calories: snap.child('calories') as int,
      carbs: snap.child('carbs').value as int,
      fat: snap.child('fat').value as int,
      protein: snap.child('protein').value as int,
      mealTime: snap.child('mealTime').value as String,
      grams: snap.child('grams').value as int,
      email: snap.child('email').value as String,
      createdOn: snap.child('createdOn').value as DateTime);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mealTime': mealTime,
      'food_name': food_name,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'grams': grams,
      'createdOn': createdOn,
      'email': email
    };
  }

  FoodTrackTask.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        mealTime = json['mealTime'],
        calories = json['calories'],
        createdOn = DateTime.parse(json['createdOn']),
        food_name = json['food_name'],
        carbs = json['carbs'],
        fat = json['fat'],
        protein = json['protein'],
        grams = json['grams'],
        email = json['email'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'id': id,
    'mealTime': mealTime,
    'createdOn': createdOn.toString(),
    'food_name': food_name,
    'calories': calories,
    'carbs': carbs,
    'fat': fat,
    'protein': protein,
    'grams': grams,
    'email': email,
  };
}