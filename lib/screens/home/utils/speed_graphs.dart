import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../data/models/run_model.dart';

class SpeedOverTimeGraph extends StatefulWidget {
  final List<RunModel> runSessions;

  SpeedOverTimeGraph({
    required this.runSessions,
  });

  @override
  State<SpeedOverTimeGraph> createState() => _SpeedOverTimeGraphState();
}

class _SpeedOverTimeGraphState extends State<SpeedOverTimeGraph> {
  double? selectedBar;
  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    charts.Color? labelColor = charts.ColorUtil.fromDartColor(Theme
        .of(context)
        .brightness == Brightness.dark ? Colors.white : Colors.black,);
    List<charts.Series<RunModel, String>> seriesList = [
      charts.Series(
        id: 'SpeedOverTime',
        data: widget.runSessions,
        domainFn: (RunModel runModel, _){
          DateTime dateRecorded = DateTime.fromMillisecondsSinceEpoch(
            runModel.timestamp,
          ).toLocal();
          return "${dateRecorded.hour < 10 ? '0' + dateRecorded.hour.toString() : dateRecorded.hour}:${dateRecorded.minute < 10 ? '0' + dateRecorded.minute.toString() : dateRecorded.minute}:${dateRecorded.second < 10 ? '0' + dateRecorded.second.toString() : dateRecorded.second}\n"
              "${dateRecorded.day} ${_months[dateRecorded.month - 1]}";
        },
        measureFn: (RunModel runModel, _) => runModel.averageSpeed,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    ];
    return charts.BarChart(
      seriesList,
      animate: true,
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
        if (selectedBar != null)
          charts.ChartTitle(
            selectedBar!.toStringAsFixed(2) + " km/h",
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea,
            titleStyleSpec: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
      ],
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport("", 5),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: labelColor,
          ), //chnage white color as per your requirement.
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: labelColor,
          ),
        ),
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel<String> selectionModel) {
            final List<charts.SeriesDatum<String>> selectedDatum =
                selectionModel.selectedDatum;
            setState(() {
              selectedBar =
                  (selectedDatum.first.datum as RunModel).averageSpeed;
            });
          },
        )
      ],
    );
  }
}
