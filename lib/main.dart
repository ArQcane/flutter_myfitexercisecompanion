import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/user_repository.dart';
import 'package:flutter_myfitexercisecompanion/screens/calories/calorie_counter_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/home/home_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/profile/edit_profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/profile/profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/tracking/run_tracker_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/auth/user_add_details_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';
import 'package:flutter_myfitexercisecompanion/screens/auth/login_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/auth/register_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/auth/reset_password_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => StreamBuilder<User?>(
        stream: AuthRepository().getAuthUser(),
        builder: (context, snapshot) {
          return MaterialApp(
              theme: ThemeData(
                colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.deepOrangeAccent,
                    primaryContainer: Colors.white,
                    onPrimary: Colors.white,
                    secondary: Colors.deepOrange,
                    onSecondary: Colors.white,
                    error: Colors.red,
                    onError: Colors.black,
                    background: Colors.white,
                    onBackground: Colors.black,
                    surface: Colors.white70,
                    onSurface: Colors.black,
                    surfaceVariant: Color(0xFF29364B)),
                primarySwatch: Colors.deepOrange,
                scaffoldBackgroundColor: Colors.white70,
                fontFamily: 'Montserrat',
              ),
              darkTheme: ThemeData(
                  colorScheme: const ColorScheme(
                      brightness: Brightness.dark,
                      primary: Color(0xFFE04D01),
                      onPrimary: Colors.white,
                      primaryContainer: Color(0xFF2A2550),
                      secondary: Color(0xFF2A2550),
                      onSecondary: Colors.white,
                      secondaryContainer: Color(0xFFFF7700),
                      error: Colors.redAccent,
                      onError: Colors.white,
                      background: Color(0xFF29364B),
                      onBackground: Colors.white,
                      surface: Color(0xFF082032),
                      onSurface: Colors.white,
                      surfaceVariant: Color(0xFF082032)),
                  scaffoldBackgroundColor: Color(0xFF251D3A),
                  fontFamily: 'Montserrat'),
              home: snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.hasData
                      ? UserAddDetailsScreen()
                      : MainScreen(),
              routes: {
                ResetPasswordScreen.routeName: (_) {
                  return ResetPasswordScreen();
                },
                HomeScreen.routeName: (_) {
                  return HomeScreen();
                },
                RunTrackerScreen.routeName: (_) {
                  return RunTrackerScreen();
                },
                CalorieCounterScreen.routeName: (_) {
                  return CalorieCounterScreen();
                },
                ProfileScreen.routeName: (_) {
                  return ProfileScreen();
                },
                UserAddDetailsScreen.routeName: (_) {
                  return UserAddDetailsScreen();
                },
                BottomNavBar.routeName: (_){
                  return BottomNavBar();
                },
                EditProfileScreen.routeName: (_) {
                  return EditProfileScreen();
                }
              });
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loginScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyFit - Exercise Companion'),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                loginScreen ? LoginForm() : RegisterForm(),
                SizedBox(height: 5),
                loginScreen
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            loginScreen = false;
                          });
                        },
                        child: Text('No account? Sign up here!'))
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            loginScreen = true;
                          });
                        },
                        child: Text('Exisiting user? Login in here!')),
                loginScreen
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ResetPasswordScreen.routeName);
                        },
                        child: Text('Forgotten Password'))
                    : Center()
              ],
            ),
          )),
    );
  }
}
