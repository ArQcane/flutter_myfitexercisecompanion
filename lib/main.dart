import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/screens/calorie_counter_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/home_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/run_tracker_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/user_add_details_screen.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';
import 'package:flutter_myfitexercisecompanion/services/firestore_service.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';
import 'package:flutter_myfitexercisecompanion/widgets/login_form.dart';
import 'package:flutter_myfitexercisecompanion/widgets/register_form.dart';
import 'package:flutter_myfitexercisecompanion/screens/reset_password_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
              stream: authService.getAuthUser(),
              builder: (context, snapshot) {
                return MaterialApp(
                    theme: ThemeData(
                      primarySwatch: Colors.deepOrange,
                    ),
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
                        return HomeScreen(snapshot.data as  User);
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
                      BottomNavBar.routeName: (_) {
                        return BottomNavBar();
                      }
                    });
              },
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
