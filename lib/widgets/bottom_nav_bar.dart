import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/calorie_counter_screen.dart';
import '../screens/home_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/tracking/run_tracker_screen.dart';

class BottomNavBar extends StatefulWidget {
  static String routeName = '/navigation-bar';


  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex =  0;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Colors.blueGrey.shade900,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:10.0,
                vertical: 5.0),
            child: GNav(
              backgroundColor: Colors.blueGrey.shade900,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.orange.shade800,
              gap: 8,
              onTabChange: (index){
                setState(() {
                  selectedIndex = index;
                });
              },
              padding: EdgeInsets.all(16),
              tabs: const[
                GButton(
                  icon: Icons.home,
                  text: 'Home',),
                GButton(icon: Icons.run_circle,
                  text: 'Run Tracker',),
                GButton(icon: Icons.no_food,
                  text: 'Calories',),
                GButton(icon: Icons.person,
                  text: 'Profile',),
              ],
            ),
          ),
        ),

        body: Center(
          child: selectedIndex == 0 ? HomeScreen() :
          selectedIndex ==   1 ? RunTrackerScreen() :
          selectedIndex == 2 ? CalorieCounterScreen() :
          ProfileScreen(),
        ));
  }
}
