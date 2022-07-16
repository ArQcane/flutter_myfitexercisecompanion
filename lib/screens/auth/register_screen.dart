import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/utils/snackbar.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../widgets/loading_circle.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? email;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool isLoading = false;
  var form = GlobalKey<FormState>();

  void submitForm() async{
    FocusScope.of(context).unfocus();
    if (form.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      form.currentState!.save();
      try {
        await AuthRepository().register(
          email,
          _pass.text,
        );
        setState(() {
          isLoading = false;
        });
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
            controller: _pass,
            validator: (value) {
              if (value == null)
                return 'Please provide a password.';
              else if (value.length < 6)
                return 'Password must be at least 6 characters.';
              else if (value != _confirmPass.text)
                return 'Passwords do not match';
              else
                return null;
            },
            onSaved: (value) {
              setState((){
                _pass.text = value!;
              });
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
            controller: _confirmPass,
            validator: (value) {
              if (value == null)
                return 'Please provide a password.';
              else if (value.length < 6)
                return 'Password must be at least 6 characters.';
              else if(value != _confirmPass.text){
                return 'Passwords do not match';
              }
              else
                return null;
            },
            onSaved: (value) {
              setState((){
                _confirmPass.text = value!;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            submitForm();
          },
          icon: Icon(Icons.app_registration),
          label: Text('Register'),
        ),
        if (isLoading) LoadingCircle(),
      ],
    ),
  );
}}
