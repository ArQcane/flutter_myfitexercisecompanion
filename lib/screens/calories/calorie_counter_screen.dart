import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/screens/calories/pages/day_view.dart';
import 'package:flutter_myfitexercisecompanion/screens/calories/pages/history_screen.dart';
import 'package:provider/provider.dart';

class CalorieCounterScreen extends StatefulWidget {
  static String routeName = "/calorie";

  const CalorieCounterScreen({Key? key}) : super(key: key);

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Day View",),
                Tab(text: "History",),
              ],
            ),
            centerTitle: true,
            title: const Text(
              "Calorie Tracker",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: DayViewScreen(),),
              Center(child: HistoryScreen(),)
            ],
          )),
    );
  }
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
