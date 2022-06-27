import 'package:flutter/material.dart';

class RunTrackerScreen extends StatefulWidget {
  static String routeName = "/runtracker";

  @override
  State<RunTrackerScreen> createState() => _RunTrackerScreenState();
}

class _RunTrackerScreenState extends State<RunTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Run Tracker')
      ],
    );
  }
}
