import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/utils/snackbar.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../data/models/run_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/run_repository.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  GlobalKey _parentKey = GlobalKey();
  GlobalKey<FormState> _updateKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<String> selectedRuns = [];
  final runTitleController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runTitleController.addListener((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Stack(
        key: _updateKey,
        children: [
          if (!isLoading)
            StreamBuilder<List<RunModel>>(
              stream: RunRepository.instance().getRunList(
                AuthRepository().getCurrentUser()!.email!,
              ),
              builder: _builder,
            ),
          if (isLoading)
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }



  Widget _builder(
    BuildContext context,
    AsyncSnapshot<List<RunModel>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingCircle(
        overlayVisibility: false,
      );
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _getNoRunsToDisplay();
    }
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: snapshot.data!.map((RunModel runModel) {
        return _getListItem(
          context,
          runModel,
        );
      }).toList(),
    );
  }

  Widget _getListItem(BuildContext context, RunModel runModel) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(runModel.timestamp));
    String? newRunTitle;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Slidable(
        key: ValueKey(runModel.id),
        endActionPane: _getActionPane(runModel),
        child: Form(
          child: GestureDetector(
            onTap: (){
              print("runtitle value:${runModel.runTitle}");
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Update this Run?"),
                  content: const Text(
                    "Title of Run: ",
                  ),
                  actions: [
                    TextFormField(
                      initialValue: runModel.runTitle.toString(),
                      onSaved: (value){
                        newRunTitle = value;
                      },
                      validator: (value) {
                        if (value! == "" || value == null)
                          return 'Please put a title that is atleast 4 letters long';
                        else if(value.length < 4){
                          return "Please put a title that is atleast 4 letters long";
                        }
                        else
                          return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                            _updateKey.currentState!.save();
                            try {
                              await RunRepository.instance().updateRun([runModel.id], newRunTitle!);
                              print("Working");
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("error: ${e.toString()}"),
                                  action: SnackBarAction(
                                    label: "OKAY",
                                    onPressed: () {},
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                        },
                        child: Text('Yes')),
                    ElevatedButton(
                      onPressed: (){Navigator.pop(context);},
                      child: Text('No'),
                    ),
                  ],
                ),
              );
            },
            child: Stack(
              children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Run Title: ${runModel.runTitle}",
                            style: GoogleFonts.montserrat(
                                textStyle:
                                    Theme.of(context).textTheme.headline5?.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.double),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recorded on: ${formattedDate}",
                            style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              height: 350,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: _getImage(runModel),
                              ),
                            ),
                            Container(
                              child: _getDetails(runModel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                _getOverlay(runModel.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ActionPane _getActionPane(RunModel runModel) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        onDismissed: () async {
          setState(() {
            isLoading = true;
          });
          try{
            await RunRepository.instance().deleteRun([runModel.id]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully deleted the run"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () { RunRepository.instance().undoDelete(runModel);},
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } catch (exception){
            SnackbarUtils(context: context).createSnackbar("An error has occurred");
          }

          setState(() {
            isLoading = false;
          });
        },
      ),
      children: [
        SlidableAction(
          onPressed: (_) async {
            setState(() {
              isLoading = true;
            });
            try{
              await RunRepository.instance().deleteRun([runModel.id]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully deleted the run"),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () { RunRepository.instance().undoDelete(runModel);},
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (exception){
              SnackbarUtils(context: context).createSnackbar("An error has occurred");
            }
            setState(() {
              isLoading = false;
            });
          },
          icon: Icons.delete,
          label: 'Delete run',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        )
      ],
    );
  }

  Widget _getImage(RunModel runModel) {
    return FutureBuilder<String>(
      future: RunRepository.instance().getImageURL(
        runModel.mapScreenshot,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingCircle(overlayVisibility: false),
          );
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snapshot.data!,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                if (loadingProgress.expectedTotalBytes == null) {
                  return Center(
                    child: LoadingCircle(overlayVisibility: false),
                  );
                }
                double percentLoaded = (loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!);
                return Center(
                  child: CircularProgressIndicator(
                    value: percentLoaded,
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _getDetails(RunModel runModel) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getValue(
            context,
            (runModel.distanceRanInMetres > 1000
                    ? runModel.distanceRanInMetres / 1000
                    : runModel.distanceRanInMetres.toInt())
                .toString(),
            runModel.distanceRanInMetres > 1000 ? 'Kilometres' : 'Metres',
          ),
          _getValue(
            context,
            StopWatchTimer.getDisplayTimeHours(
                    runModel.timeTakenInMilliseconds) +
                ":" +
                StopWatchTimer.getDisplayTimeMinute(
                    runModel.timeTakenInMilliseconds) +
                ":" +
                StopWatchTimer.getDisplayTimeSecond(
                    runModel.timeTakenInMilliseconds),
            'Time Taken',
          ),
          _getValue(
            context,
            runModel.averageSpeed.toStringAsFixed(2),
            'KM/h',
          ),
        ],
      ),
    );
  }

  Widget _getValue(BuildContext context, String value, String unit) {
    return SizedBox(
      width: (300) / 3,
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.headline6?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ),
          Text(unit,
              style: GoogleFonts.montserrat(
                textStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 14, color: Colors.deepOrangeAccent),
              )),
        ],
      ),
    );
  }

  Widget _getOverlay(String id) {
    return Visibility(
      visible: selectedRuns.contains(id),
      child: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.all(5),
        height: (100 - 20) / 2 + 60,
        color: Theme.of(context).focusColor,
        child: const Icon(
          Icons.check_box,
          color: Colors.blue,
          size: 50,
        ),
      ),
    );
  }

  Widget _getNoRunsToDisplay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'images/no_runs.png',
              width: 400,
              height: 400,
            ),
          ),
          Text(
            "There are no runs recorded yet",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            "Try adding one today!",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
