import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/main.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_detail.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../utils/snackbar.dart';

class UserAddDetailsScreen extends StatefulWidget {
  static String routeName = '/add-details';

  @override
  State<UserAddDetailsScreen> createState() => _UserAddDetailsScreenState();
}

class _UserAddDetailsScreenState extends State<UserAddDetailsScreen> {
  var form = GlobalKey<FormState>();

  String? email;

  String? username;

  double? height;

  double? weight;

  String profilePic = "";

  late User? currentLoggedInFirebaseUser;

  bool isLoading = false;
  bool isUploading = false;

  // Future<void> pickUpLoadImage() async {
  //   final image = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       maxHeight: 512,
  //       maxWidth: 512,
  //       imageQuality: 75);
  //
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("${authService.getCurrentUser()?.uid}_profilepic");
  //
  //   await ref.putFile(File(image!.path));
  //   ref.getDownloadURL().then((value) {
  //     setState(() {
  //       profilePic = value;
  //     });
  //   });
  // }


  void saveForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (form.currentState!.validate()) {
      form.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        bool insertResults = await UserRepository.instance().insertUser(
          UserDetail(
              username: username!,
              email: AuthRepository().getCurrentUser()!.email!,
              height: height!,
              weight: weight!,
              profilePic: profilePic
          ),
        );
        setState(() {
          isLoading = false;
        });
        if (!insertResults) {
          SnackbarUtils(context: context).createSnackbar(
            'Unknown Error has Occurred',
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BottomNavBar(),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        SnackbarUtils(context: context).createSnackbar(
          (e as FirebaseException).message.toString(),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder<UserDetail?>(
          future: UserRepository.instance().getUser(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return LoadingCircle();
            }
            if(snapshot.connectionState == ConnectionState.done){
              Future.delayed(Duration.zero, () async {
                Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
              });
            }
            return Scaffold(
              appBar: AppBar(
                title: Text('User Details'),
                actions: [
                  IconButton(
                      onPressed: () {
                        saveForm(context);
                      },
                      icon: Icon(Icons.save))
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      child: Form(
                        key: form,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 250,
                              padding: const EdgeInsets.all(50),
                              child: Image.asset(
                                  'images/fit_running_logo_template_transparent.png'),
                            ),
                            TextFormField(
                              decoration:
                              InputDecoration(label: Text("Username")),
                              onSaved: (value) {
                                username = value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please provide a username.";
                                } else
                                  return null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Height")),
                              validator: (value) {
                                if (value == null) {
                                  return "Please provide your height in cm.";
                                } else if (double.tryParse(value) == null) {
                                  return "Please provide a valid height.";
                                } else if (double.tryParse(value)! < 100) {
                                  return "Please provide a height that is above 100cm";
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                height = double.parse(value!);
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Weight")),
                              validator: (value) {
                                if (value == null) {
                                  return "Please provide your weight in kg.";
                                } else if (double.tryParse(value) == null) {
                                  return "Please provide a valid weight.";
                                } else if (double.tryParse(value)! < 40) {
                                  return "Please provide a weight that is humanly possible";
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                weight = double.parse(value!);
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isLoading) LoadingCircle()
                ],
              ),
            );
          }
      ),
    );
  }
}