import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_model.dart';
import 'package:flutter_myfitexercisecompanion/screens/auth/user_add_details_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/bottom_nav_bar.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email;
  String? password;
  bool isLoading = false;
  var form = GlobalKey<FormState>();

  void submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (form.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      form.currentState?.save();
      try {
        await AuthRepository.instance().login(
          email,
          password,
        );
        form.currentState?.reset();
        UserDetail? user = await UserRepository.instance().getUser();
        print("user details ${user}");
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(
          context,
          user == null ? UserAddDetailsScreen.routeName : BottomNavBar.routeName,
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((e as FirebaseException).message.toString()),
            action: SnackBarAction(
              label: "OKAY",
              onPressed: () {},
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            "images/fit_running_logo_template_transparent.png",
            height: 300,
            width: 300,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  icon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null)
                  return "Please provide an email address.";
                else if (!value.contains('@'))
                  return "Please provide a valid email address.";
                else
                  return null;
              },
              onSaved: (value) {
                email = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  icon: Icon(Icons.password)),
              obscureText: true,
              validator: (value) {
                if (value == null)
                  return 'Please provide a password.';
                else if (value.length < 6)
                  return 'Password must be at least 6 characters.';
                else
                  return null;
              },
              onSaved: (value) {
                password = value;
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              submitForm(context);
            },
            icon: Icon(Icons.login),
            label: Text('Login'),
          ),
        ],
      ),
    );
  }
}
