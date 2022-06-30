import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email;
  String? password;
  var form = GlobalKey<FormState>();

  login() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      AuthService authService = AuthService();
      return authService.login(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successfully!'),
        ));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
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
              login();
            },
            icon: Icon(Icons.login),
            label: Text('Login'),
          ),
        ],
      ),
    );
  }
}
