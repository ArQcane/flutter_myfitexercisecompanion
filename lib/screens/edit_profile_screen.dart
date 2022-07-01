import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/models/user.dart';
import 'package:flutter_myfitexercisecompanion/screens/profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firestore_service.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var form = GlobalKey<FormState>();

  FirestoreService fsService = FirestoreService();
  AuthService authService = AuthService();

  String? email;
  String profilePic = '';
  String? username;
  double? weight;
  double? height;
  XFile? image;


  Future<void> pickUpLoadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${authService.getCurrentUser()?.uid}_profilepic");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        profilePic = value;
      });
    });
  }

  saveForm(String email) {
    bool isValid = form.currentState!.validate();


    if (profilePic == "") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please include a profile picture!'),
      ));
      return;
    }

    if (isValid) {
      form.currentState!.save();

      FirestoreService fsService = FirestoreService();
      print(profilePic);

      return fsService.updateCurrentFirestoreUser(
          email, profilePic, username, height, weight).then((value) {
        FocusScope.of(context).unfocus();
        form.currentState!.reset();
        Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User Profile editted successfully!'),));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message),));
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      UserDetail currentUser =
      ModalRoute
          .of(context)
          ?.settings
          .arguments as UserDetail;

      if(profilePic == ''){
        profilePic = currentUser.profilePic;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  saveForm(currentUser.email);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: Container(
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
                      SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                  radius: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(profilePic),
                                  )
                              ),
                              Positioned(
                                bottom: 0,
                                right: -15,
                                child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        side: BorderSide(
                                            color: Colors.orangeAccent)),
                                    color: Color(0xFFF5F6F9),
                                    onPressed: () {
                                      pickUpLoadImage();
                                    },
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  initialValue: currentUser.email,
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
                  initialValue: currentUser.username,
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
                  initialValue: currentUser.height.toStringAsFixed(2),
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
                  initialValue: currentUser.weight.toStringAsFixed(2),
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
        ),
      );
    }
}
