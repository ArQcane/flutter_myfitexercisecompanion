import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/calorie_counter_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/run_tracker_screen.dart';
import '../services/auth_service.dart';

class BottomNavBar extends StatefulWidget {
  static String routeName = '/navigation-bar';


  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex =  0;
  AuthService authService = AuthService();

  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? currentUser;

  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    final uid = user?.uid;
    currentUser = user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: selectedIndex == 0 ? Text('Home') :
          selectedIndex == 1 ? Text('Run Tracking') :
          selectedIndex == 2 ? Text('Calories Counter') :
          Text('Profile'),
        ),
        bottomNavigationBar: Container(
          color: Colors.blueGrey.shade900,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:15.0,
                vertical: 7.0),
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
          child: selectedIndex == 0 ? HomeScreen(currentUser!) :
          selectedIndex ==   1 ? RunTrackerScreen() :
          selectedIndex == 2 ? CalorieCounterScreen() :
          ProfileScreen(),
        ));
  }
}
