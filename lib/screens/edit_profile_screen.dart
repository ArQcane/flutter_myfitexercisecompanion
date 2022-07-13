import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_detail.dart';

import 'package:flutter_myfitexercisecompanion/screens/profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:flutter_myfitexercisecompanion/widgets/profile_picture.dart';

import 'package:image_picker/image_picker.dart';

import '../data/repositories/user_repository.dart';
import '../utils/snackbar.dart';



class EditProfileScreen extends StatefulWidget {
  static String routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var form = GlobalKey<FormState>();
  UserDetail? _userDetail;

  String? email;
  String profilePic = '';
  String? username;
  double? weight;
  double? height;
  XFile? image;

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
      final Map<String, dynamic> map = {};
      if (username != _userDetail!.username) {
        map["username"] = username;
      }
      if (weight != _userDetail!.weight) {
        map["weight"] = weight;
      }
      if (height != _userDetail!.height) {
        map["height"] = height;
      }
      if (map.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return SnackbarUtils(context: context)
            .createSnackbar('No data has been changed!');
      }
      try {
        bool updateResults = await UserRepository.instance().updateUser(
          map: map,
        );
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text( updateResults
                ? 'Account updated successfully!'
                : 'Unknown error has occurred'),
            action: SnackBarAction(
              label: "OKAY",
              onPressed: () {},
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text( (e as FirebaseException).message.toString()),
            action: SnackBarAction(
              label: "OKAY",
              onPressed: () {},
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  saveForm(context);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: StreamBuilder<UserDetail?>(
          stream: UserRepository.instance().getUserStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || isUploading) {
              return LoadingCircle(
                overlayVisibility: false,
              );
            }
            if (snapshot.hasData) {
              _userDetail = snapshot.data;
              username = _userDetail?.username;
              weight = _userDetail?.weight;
              height = _userDetail?.height;
            }
            return Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: form, //assigning the form to the key
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProfileImage(width: double.infinity, snapshot: snapshot)
                        ],
                      ),
                    ),
                    TextFormField(
                      initialValue: _userDetail?.email,
                      decoration: InputDecoration(label: Text("Email Registered")),
                      onSaved: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please provide a valid email address";
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: snapshot.data?.username,
                      decoration: InputDecoration(label: Text("Username")),
                      validator: (value) {
                        if (value == null) {
                          return "Please enter a username";
                        }
                        if (value.length < 5) {
                          return "Please include a username longer than 5 letters long";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        username = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _userDetail?.height.toStringAsFixed(2),
                      decoration: InputDecoration(label: Text("Height")),
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
                      initialValue: _userDetail?.weight.toStringAsFixed(2),
                      decoration: InputDecoration(label: Text("Weight")),
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
                  ],
                ),
              ),
            );
          }
        ),
      );
    }
}
