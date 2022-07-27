import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/screens/calories/pages/day_view.dart';
import 'package:flutter_myfitexercisecompanion/screens/calories/pages/history_screen.dart';
import 'package:provider/provider.dart';

class CalorieCounterScreen extends StatefulWidget {
  static String routeName = "/calorie";

  const CalorieCounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            // Navigate back to homepage
          },
          child: const Text('Go Back!'),
        ),
      ),
    );
  }

  @override
  State<CalorieCounterScreen> createState() => _CalorieCounterScreenState();
}

class _CalorieCounterScreenState extends State<CalorieCounterScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onClickHistoryScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  void onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DayViewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Flutter Calorie Tracker App",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            const ListTile(
                leading: Icon(Icons.food_bank),
                title: Text("Welcome To Calorie Tracker App!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ElevatedButton(
                onPressed: () {
                  onClickDayViewScreenButton(context);
                },
                child: const Text("Day View Screen")),
            ElevatedButton(
                onPressed: () {
                  onClickHistoryScreenButton(context);
                },
                child: const Text("History Screen")),
          ],
        ));
  }
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
