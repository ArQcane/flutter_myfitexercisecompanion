import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/run_model.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/auth_repository.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/run_repository.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import '../../utils/snackbar.dart';

class RunTrackerScreen extends StatefulWidget {
  static String routeName = "/runtracker";

  @override
  State<RunTrackerScreen> createState() => _RunTrackerScreenState();
}

class _RunTrackerScreenState extends State<RunTrackerScreen> {
  final Set<Polyline> polyline = {};
  final Location _location = Location();
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(1.35297, 103.865);
  final List<List<LatLng>> _runRoute = [];

  double _dist = 0;
  String? _displayTime;
  int? _time;
  double _speed = 0;
  String runTitle = "";

  bool isTracking = false;
  bool isFirstTimeTracking = true;
  bool takingMapScreenshot = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _runTitleController.addListener(() {
      runTitle = _runTitleController.text;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
    _mapController!.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _location.onLocationChanged.listen((event) {
      if (isTracking == false)
        return;
      else {
        notificationManagerConfiguration();
        print("working");
        LatLng loc = LatLng(event.latitude!, event.longitude!);
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: 15)));
        print("route list: $_runRoute");
        _runRoute.last.add(
          LatLng(
            event.latitude!,
            event.longitude!,
          ),
        );

        if (_runRoute.length > 0) {
          double distanceRan = 0;
          for (List<LatLng> list in _runRoute) {
            for (int i = 0; i < list.length - 1; i++) {
              // distanceRan += _calculateDistance(list[i], list[i + 1]);
              distanceRan = Geolocator.distanceBetween(
                  list[i].latitude,
                  list[i].longitude,
                  list[i + 1].latitude,
                  list[i + 1].longitude);
            }
          }
          setState(() {
            _dist += distanceRan;
            _speed = (_dist / (_time! / 100)) * 3.6 * 10;
          });
        }

        setState(() {
          for (var indivRoute in _runRoute) {
            polyline.add(Polyline(
                polylineId: PolylineId(event.toString()),
                visible: true,
                points: indivRoute,
                width: 5,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                color: Colors.deepOrange));
          }
        });
      }
    });
  }

  void _handleClick() {
    setState(() {
      isTracking = !isTracking;
      if (isFirstTimeTracking) {
        isFirstTimeTracking = false;
      }
      if (!isTracking) {
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        return;
      }
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      _runRoute.add([]);
      _location.enableBackgroundMode();
    });
  }

  void showDialogForTitle(BuildContext context) {
    if (_runRoute.isEmpty || _runRoute[0].length < 2 || takingMapScreenshot)
      return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account?'),
        content:
            Text('Are you sure you want to delete your account permanently?'),
        actions: [
          TextField(
            controller: _runTitleController,
          ),
          ElevatedButton(
              onPressed: () {
                saveRun();
                Navigator.pop(context);
              },
              child: Text('Yes')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void saveRun() async {
    if (_runRoute.isEmpty || _runRoute[0].length < 2 || takingMapScreenshot)
      return;
    setState(() {
      isTracking = false;
      takingMapScreenshot = true;
    });
    print("mapscreenshot value: $takingMapScreenshot");
    print("runtitle value: $runTitle");
    await Future.delayed(
      const Duration(milliseconds: 200),
      null,
    );
    _location.enableBackgroundMode(enable: false);
    Uint8List? mapScreenshot = await _mapController?.takeSnapshot();
    String mapScreenshotRef = "screenshot(map)/${const Uuid().v4()}";

    RunModel runModel = RunModel(
        id: '',
        email: AuthRepository.instance().getCurrentUser()!.email!,
        runTitle: runTitle,
        mapScreenshot: mapScreenshotRef,
        timeTakenInMilliseconds: _time!,
        distanceRanInMetres: _dist,
        averageSpeed: _speed);

    bool waitingForInsert =
        await RunRepository.instance().insertRun(runModel, mapScreenshot!);

    if (!waitingForInsert) {
      return SnackbarUtils(context: context)
          .createSnackbar('Unknown Error has occurred');
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BottomNavBar(),
      ),
    );
  }

  void cancelRun(BuildContext context) {
    if (isFirstTimeTracking) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BottomNavBar(),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel the run?"),
        content: const Text(
          "Are you sure you want to delete the current run and lose all its data forever?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isTracking = false;
              });
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BottomNavBar(),
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void notificationManagerConfiguration() async {
    print("displayTime: $_displayTime");
    await _location.changeNotificationOptions(
      title: 'MyFitExerciseTracker',
      subtitle:
          "$_displayTime  ||  ${(_dist / 1000).toStringAsFixed(2)} km  ||  ${_speed.toStringAsFixed(2)} km/h}",
      iconName: "fit_running_logo_template.png",
      color: Colors.deepOrangeAccent,
      onTapBringToFront: true,
    );
  }

  final _runTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Run Tracker"),
          actions: [
            if (!isTracking && !isFirstTimeTracking)
              IconButton(
                onPressed: () {
                  setState(() {
                    showDialogForTitle(context);
                  });
                },
                icon: const Icon(Icons.save),
              ),
            if (isTracking || !isFirstTimeTracking)
              IconButton(
                onPressed: () {
                  cancelRun(context);
                },
                icon: const Icon(Icons.close),
              )
          ],
        ),
        body: Stack(children: [
          Container(
              child: GoogleMap(
            polylines: polyline,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11),
          )),
          if (!takingMapScreenshot) ActionPlatform(),
          if (takingMapScreenshot)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Material(
                elevation: 10,
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingCircle(
                      overlayVisibility: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Do not close the app',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      'Your run is being saved',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ),
        ]));
  }

  Widget ActionPlatform() {
    return Container(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
            height: 140,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("SPEED (KM/H)",
                            style: GoogleFonts.montserrat(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        Text(_speed.toStringAsFixed(2),
                            style: GoogleFonts.montserrat(
                                fontSize: 30, fontWeight: FontWeight.w300))
                      ],
                    ),
                    Column(
                      children: [
                        Text("TIME",
                            style: GoogleFonts.montserrat(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: 0,
                          builder: (context, snap) {
                            _time = snap.data;
                            _displayTime = StopWatchTimer.getDisplayTimeHours(
                                    _time!) +
                                ":" +
                                StopWatchTimer.getDisplayTimeMinute(_time!) +
                                ":" +
                                StopWatchTimer.getDisplayTimeSecond(_time!);
                            return Text(_displayTime!,
                                style: GoogleFonts.montserrat(
                                    fontSize: 30, fontWeight: FontWeight.w300));
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("DISTANCE (KM)",
                            style: GoogleFonts.montserrat(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        Text((_dist / 1000).toStringAsFixed(2),
                            style: GoogleFonts.montserrat(
                                fontSize: 30, fontWeight: FontWeight.w300))
                      ],
                    )
                  ],
                ),
                Divider(),
                IconButton(
                  icon: isTracking == true
                      ? const Icon(
                          Icons.stop_circle_outlined,
                          size: 50,
                          color: Colors.redAccent,
                        )
                      : const Icon(
                          Icons.play_circle_outlined,
                          size: 50,
                          color: Colors.greenAccent,
                        ),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    _handleClick();
                  },
                )
              ],
            ),
          )),
    );
  }
}
