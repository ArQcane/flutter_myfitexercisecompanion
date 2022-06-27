import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/db/run_session_dao.dart';
import 'package:flutter_myfitexercisecompanion/db/run_session_database.dart';
import 'package:flutter_myfitexercisecompanion/screens/calorie_counter_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/home_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/profile_screen.dart';
import 'package:flutter_myfitexercisecompanion/screens/run_tracker_screen.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';
import 'package:flutter_myfitexercisecompanion/widgets/login_form.dart';
import 'package:flutter_myfitexercisecompanion/widgets/register_form.dart';
import 'package:flutter_myfitexercisecompanion/screens/reset_password_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorRunSessionDatabase.databaseBuilder('run_session_database.db').build();

  final runSessionDao = database.runSessionDao;
  await Firebase.initializeApp();
  runApp(MyApp(runSessionDao));
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();

  final RunSessionDao dao;

  MyApp(this.dao);


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
                            ? NavigationBar(dao)
                            : MainScreen(dao),
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
                    });
              },
    );
  }
}

class NavigationBar extends StatefulWidget {
  final RunSessionDao dao;

  NavigationBar(this.dao);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
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


class MainScreen extends StatefulWidget {
  static String routeName = '/';
  final RunSessionDao dao;

  MainScreen(this.dao);

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
