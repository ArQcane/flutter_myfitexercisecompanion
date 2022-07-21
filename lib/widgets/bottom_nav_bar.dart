import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/calorie_counter_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/tracking/run_tracker_screen.dart';

class BottomNavBar extends StatefulWidget {
  static String routeName = '/navigation-bar';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:10.0,
                vertical: 5.0),
            child: GNav(
              rippleColor: Colors.grey.shade800, // tab button ripple color when pressed
              hoverColor: Colors.grey.shade700, // tab button hover color
              haptic: true, // haptic feedback
              tabShadow: [BoxShadow(color: Colors.blueGrey.withOpacity(0.3), blurRadius: 5)], // tab button shadow
              iconSize: 24, // tab button icon size
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
              gap: 8,
              selectedIndex: selectedIndex,
              onTabChange: (index){
                _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
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

        body: PageView(
          controller: _pageController,
          onPageChanged: (newIndex){
            setState((){
              selectedIndex = newIndex;
            });
          },
          children: [
            HomeScreen(),
            RunTrackerScreen(),
            CalorieCounterScreen(),
            ProfileScreen(),
          ]
        ));
  }
}
