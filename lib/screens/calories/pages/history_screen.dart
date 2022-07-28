import 'package:flutter/material.dart';

import '../../../utils/datetime_series_chart.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen();

  @override
  State<StatefulWidget> createState() {
    return _HistoryScreenState();
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBack = true;
  @override
  void initState() {
    super.initState();
  }

  void onClickBackButton() {
    print("Back Button");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: DateTimeChart(),
        ));
  }
}
