import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/main.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";


  User currentUser;
  HomeScreen(this.currentUser);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex =  0;

  logOut() {
    AuthService authService = AuthService();
    return authService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logout successfully!'),
      ));
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Hello ' + widget.currentUser.email! + '!'),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                logOut();
              },
              child: Text('Log out'))
        ],
    );
  }
}
