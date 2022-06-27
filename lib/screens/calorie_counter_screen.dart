import 'package:flutter/material.dart';

class CalorieCounterScreen extends StatefulWidget {
  static String routeName = "/calorie";

  @override
  State<CalorieCounterScreen> createState() => _CalorieCounterScreenState();
}

class _CalorieCounterScreenState extends State<CalorieCounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Calories')
      ],
    );
  }
}
