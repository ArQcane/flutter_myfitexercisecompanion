import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import 'loading_circle.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? email;
  String? password;
  String? confirmPassword;
  bool isLoading = false;
  var form = GlobalKey<FormState>();

  void submitForm(BuildContext context) async{
    FocusScope.of(context).unfocus();
    if (form.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      form.currentState!.save();
      try {
        await AuthRepository().register(
          email,
          password,
        );
        setState(() {
          isLoading = false;
        });
        AuthRepository().logOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account successfully created"),
            action: SnackBarAction(
              label: "OKAY",
              onPressed: () {},
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        form.currentState!.reset();
        Navigator.of(context).pop();
      } catch (exception) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:  Text((exception as FirebaseException).message.toString()),
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
          'images/fit_running_logo_template_transparent.png', height: 300,
          width: 300,),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(label: Text('Email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
            decoration: InputDecoration(label: Text('Password'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              icon: Icon(Icons.password),),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(label: Text('Confirm Password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                icon: Icon(Icons.checklist_rtl_outlined)),
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
              confirmPassword = value;
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            submitForm(context);
          },
          icon: Icon(Icons.app_registration),
          label: Text('Register'),
        ),
        if (isLoading) LoadingCircle(),
      ],
    ),
  );
}}
