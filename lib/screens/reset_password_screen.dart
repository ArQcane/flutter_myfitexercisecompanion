import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? email;
  var form = GlobalKey<FormState>();
  reset() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      AuthService authService = AuthService();
      return authService.forgotPassword(email).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please check your email for to reset your password!'),
        ));
        Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password?'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('images/fit_running_logo_template_transparent.png', height: 300, width: 300,),
                Text("Do you happen to have forgotten your password? Enter the email you registered your account under to receive a reset password link",
                style: TextStyle(fontSize: 24,),
                textAlign: TextAlign.center,),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text('Email'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
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
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      reset();
                    },
                    child: Text('Reset Password')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
