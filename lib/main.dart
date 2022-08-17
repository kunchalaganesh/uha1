import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:uha1/loginscreens/home_page.dart';
import 'package:uha1/loginscreens/login_screen.dart';
import 'package:uha1/loginscreens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

DatabaseReference userref =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreen(
            seconds: 5,
            navigateAfterSeconds: landingpage(),
            image: new Image.asset('assets/logo.jpeg'),
            photoSize: 100.0,
            backgroundColor: Colors.blue,
            styleTextUnderTheLoader: new TextStyle(),
            loaderColor: Colors.white)

        // home: landingpage(),
        );
  }
}

class landingpage extends StatelessWidget {
  // const landingpage({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initilizer = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initilizer,
      builder: (context, snapshot) {
        log(snapshot.hashCode);
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("error"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = FirebaseAuth.instance.currentUser; //snapshot.data;
                if (user == null) {
                  return signup_screen();
                } else {
                  if (user.emailVerified) {
                    return home_page();
                  } else {
                    return login_screen();
                  }
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("Connecting"),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text("Loading please wait..."),
          ),
        );
      },

    );
  }
}
