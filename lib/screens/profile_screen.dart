import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/screens/edit_profile_screen.dart';

import '../main.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  User currentUser;

  ProfileScreen(this.currentUser);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirestoreService fsService = FirestoreService();
  AuthService authService = AuthService();

  final passwordController = TextEditingController();

  String? password;

  deleteAccount() async{
    bool step1 = true ;
    bool step2 = false ;
    bool step3 = false ;
    bool step4 = false ;
    while(true){

      if(step1){
        //delete user info in the database
        var user = authService.getCurrentUser();
        var credential = EmailAuthProvider.credential(email: authService.getCurrentUser()!.email.toString(), password: password!);
        await user?.reauthenticateWithCredential(credential);
        await fsService.deleteCurrentFirestoreUser(authService.getCurrentUser()!.email);
        step1 = false;
        step2 = true;
      }

      if(step2){
        //delete user
        authService.getCurrentUser()!.delete();
        step2 = false ;
        step3 = true;
      }

      if(step3){
        await authService.logOut();
        step3 = false;
        step4 = true ;

      }

      if(step4){
        //go to sign up log in page
        await Navigator.pushNamed(context, '/');
        step4 = false ;
      }

      if(!step1 && !step2 && !step3 && !step4 ) {
        break;
      }

    }
  }

  logOut() {
    return authService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logout successfully!'),
      ));
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordController.addListener(() {password = passwordController.text;});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetail>(
        future: fsService
            .getCurrentFirestoreUserData(authService.getCurrentUser()!.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                          ),
                          color: Colors.deepOrangeAccent),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50,
                            left: 0,
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  )),
                            ),
                          ),
                          const Positioned(
                            top: 75,
                            left: 20,
                            child: Text(
                              'Your Profile',
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 5, top: 5 // Space between underline and text
                          ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1.0, // Underline thickness
                      ))),
                      child: Text(
                        "Hello ${snapshot.data!.username}",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                                fit: StackFit.expand,
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                      radius: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                            snapshot.data!.profilePic),
                                      )),
                                  Positioned(
                                    bottom: 0,
                                    right: -15,
                                    child: SizedBox(
                                      height: 46,
                                      width: 46,
                                      child: FlatButton(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            side: BorderSide(
                                                color: Colors.orangeAccent)),
                                        color: Color(0xFFF5F6F9),
                                        onPressed: () {},
                                        child: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ProfileMenu(
                        icon: Icon(Icons.person_outline,
                            color: Colors.deepOrange, size: 25),
                        text: "Edit Account",
                        press: () => Navigator.pushNamed(
                            context, EditProfileScreen.routeName,
                            arguments: snapshot.data!)),
                    ProfileMenu(
                      icon: Icon(Icons.logout_outlined,
                          color: Colors.deepOrange, size: 25),
                      text: "Logout",
                      press: () {
                        logOut();
                      },
                    ),
                    ProfileMenu(
                        text: "Delete Account?",
                        icon: Icon(Icons.delete_forever_outlined, color: Colors.deepOrange, size: 25,),
                        press: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text('Delete Account?'),
                                  content: Text('Are you sure you want to delete your account permanently?'),
                                  actions: [
                                    TextField(
                                      controller: passwordController,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          deleteAccount();
                                        },
                                        child: Text('Yes')),
                                    ElevatedButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Text('No'),
                                    ),
                                  ],
                                ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}


class ShowDialog extends StatefulWidget {

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  FirestoreService fsService = FirestoreService();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AlertDialog(
        title: Text('Account Deletion'),
        content: Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text('YES', style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('NO', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}



class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.grey.shade100,
        onPressed: press,
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
