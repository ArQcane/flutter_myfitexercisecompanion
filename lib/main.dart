import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/services/auth_service.dart';
import 'package:flutter_myfitexercisecompanion/widgets/home_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/login_form.dart';
import 'package:flutter_myfitexercisecompanion/widgets/register_form.dart';
import 'package:flutter_myfitexercisecompanion/widgets/reset_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<User?>(
              stream: authService.getAuthUser(),
              builder: (context, snapshot) {
                return MaterialApp(
                    theme: ThemeData(
                      primarySwatch: Colors.deepOrange,
                    ),
                    home: snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : snapshot.hasData
                            ? HomeScreen(snapshot.data as User)
                            : MainScreen(),
                    routes: {
                      ResetPasswordScreen.routeName: (_) {
                        return ResetPasswordScreen();
                      },
                      HomeScreen.routeName: (_) {
                        return HomeScreen(snapshot.data as  User);
                      },
                    });
              }),
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
        title: Text('Firebase Auth App'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
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
          )),
    );
  }
}
