import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/main.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';
import 'package:flutter_myfitexercisecompanion/services/firestore_service.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';

class UserAddDetailsScreen extends StatefulWidget {
  static String routeName = '/add-details';

  @override
  State<UserAddDetailsScreen> createState() => _UserAddDetailsScreenState();
}

class _UserAddDetailsScreenState extends State<UserAddDetailsScreen> {
  var form = GlobalKey<FormState>();
  AuthService authService = AuthService();
  FirestoreService fsService = FirestoreService();

  String? email;

  String? username;

  double? height;

  double? weight;

  late User? currentLoggedInFirebaseUser;

  void saveForm() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      print(email);
      print(username);
      print(height!.toStringAsFixed(2));
      print(weight!.toStringAsFixed(2));

      email = authService.getCurrentUser()!.email;
      fsService.addUser(email, username, height, weight);
      fsService.getCurrentFirestoreUser(email);

      FocusScope.of(context).unfocus();

      form.currentState!.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User added successfully!'),
        ),
      );
      Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fsService.getCurrentFirestoreUser(authService.getCurrentUser()!.email),
      builder: (ctx, ss) {
        if(ss.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(ss.hasData){
          return BottomNavBar();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('User Details'),
            actions: [
              IconButton(
                  onPressed: () {
                    saveForm();
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
                  TextFormField(
                    decoration: InputDecoration(label: Text("Username")),
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
      });
  }
}