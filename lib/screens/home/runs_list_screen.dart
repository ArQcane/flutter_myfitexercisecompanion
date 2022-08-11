import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/screens/home/runs_list_screen.dart';
import 'package:flutter_myfitexercisecompanion/utils/snackbar.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../data/models/run_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/run_repository.dart';

class RunsListScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<RunsListScreen> createState() => _RunsListScreen();
}

class _RunsListScreen extends State<RunsListScreen> {
  GlobalKey<FormState> _updateKey = GlobalKey<FormState>();
  bool isLoading = false;
  final runTitleController = TextEditingController();
  List<String> items = [
    'timestamp',
    'distanceRan',
    'averageSpeed',
    'timeTaken'
  ];
  String? selectedItem = 'timestamp';

  Color get _baseColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[300]!;
  }

  Color get _highlightColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[100]!
        : Colors.grey[50]!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runTitleController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Runs', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          if (!isLoading)
            StreamBuilder<List<RunModel>>(
              stream: RunRepository.instance().sortRunsByTypeList(
                AuthRepository().getCurrentUser()!.email!,
                selectedItem!,
              ),
              builder: _builder,
            ),
          if (isLoading)
            LoadingCircle(
              overlayVisibility: true,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12)
              ),
              child: DropdownButtonFormField<String>(
                icon: Icon(Icons.sort),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.primary))),
                value: selectedItem,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 24),
                        ),
                        value: item,
                      ),
                    )
                    .toList(),
                onChanged: (item) => setState(() => selectedItem = item),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!.map((RunModel runModel) {
              return _getListItem(
                context,
                runModel,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _getListItem(BuildContext context, RunModel runModel) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(runModel.timestamp));
    String? newRunTitle;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Slidable(
        key: ValueKey(runModel.id),
        endActionPane: _getActionPane(runModel),
        child: GestureDetector(
          onTap: () {
            print("runtitle value:${runModel.runTitle}");
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Update this Run?"),
                content: const Text(
                  "Title of Run: ",
                ),
                actions: [
                  Form(
                    key: _updateKey,
                    child: TextFormField(
                      initialValue: runModel.runTitle,
                      onSaved: (value) {
                        newRunTitle = value;
                      },
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return 'Please put a title that is atleast 4 letters long';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_updateKey.currentState?.validate() == true) {
                          _updateKey.currentState!.save();
                          try {
                            await RunRepository.instance().updateRun(
                                [runModel.id],
                                newRunTitle ?? runModel.runTitle);
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
                        }
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
          },
          child: Stack(
            children: [
              Material(
                color: Theme.of(context).colorScheme.primaryContainer,
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
                          textStyle:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 350,
                          child: _getImage(runModel),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              )),
                          child: _getDetails(runModel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
          try {
            await RunRepository.instance().deleteRun([runModel.id]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully deleted the run"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    RunRepository.instance().undoDelete(runModel);
                  },
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } catch (exception) {
            SnackbarUtils(context: context)
                .createSnackbar("An error has occurred");
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
            try {
              await RunRepository.instance().deleteRun([runModel.id]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully deleted the run"),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      RunRepository.instance().undoDelete(runModel);
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (exception) {
              SnackbarUtils(context: context)
                  .createSnackbar("An error has occurred");
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
          Theme.of(context).brightness == Brightness.light
              ? runModel.mapScreenshot
              : runModel.darkMapScreenshot),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingCircle(overlayVisibility: false),
          );
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.network(
            snapshot.data!,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                child: Container(
                  color: _baseColor,
                ),
                baseColor: _baseColor,
                highlightColor: _highlightColor,
              );
            },
          ),
        );
      },
    );
  }

  Widget _getDetails(RunModel runModel) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
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
      width: 330 / 3,
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.headline6?.copyWith(
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Text(unit,
              style: GoogleFonts.montserrat(
                textStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 14),
              )),
        ],
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
