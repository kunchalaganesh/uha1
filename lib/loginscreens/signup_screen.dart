import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uha1/loginscreens/login_screen.dart';

import '../main.dart';
import 'home_page.dart';

class signup_screen extends StatefulWidget {
  const signup_screen({Key? key}) : super(key: key);

  @override
  State<signup_screen> createState() => _signup_screenState();
}

class _signup_screenState extends State<signup_screen> {
  TextEditingController tcname = TextEditingController();
  TextEditingController tcemail = TextEditingController();
  TextEditingController tcpassword = TextEditingController();
  TextEditingController tcrepassword = TextEditingController();
  static const String idScreen = "register";
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/mregister.png'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(top: 150, left: 30, right: 30),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Image(
                  image: AssetImage("assets/logo.jpeg"),
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: tcname,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Enter name",
                  ),
                ),
                SizedBox(
                  height: 1.0,
                ),
                TextField(
                  controller: tcemail,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Enter email",
                  ),
                ),
                SizedBox(
                  height: 1.0,
                ),
                TextField(
                  controller: tcpassword,
                  obscureText: isHidden,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    suffixIcon: IconButton(
                      icon: isHidden?
                      Icon(Icons.visibility):
                      Icon(Icons.visibility_off),
                      onPressed: togglePasswordVisibility,
                    )
                  ),
                ),
                SizedBox(
                  height: 1.0,
                ),
                TextField(
                  controller: tcrepassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Re-Enter Password",
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontFamily: "Brand Blod",
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (tcname.text.length < 4) {
                      Fluttertoast.showToast(msg: "incorrect name");
                    } else if (tcemail.text.isEmpty ||
                        !tcemail.text.contains("@")) {
                      Fluttertoast.showToast(msg: "Enter correct email");
                    } else if (tcpassword.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Password");
                    } else if (tcrepassword.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Reenter password");
                    } else if (tcpassword.text != (tcrepassword.text)) {
                      Fluttertoast.showToast(
                          msg: "password and reenter password doesn't match");
                    } else {
                      registernewuser(context);
                    }
                  },
                ),

                SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Alrady Have Account? Login",
                        style: TextStyle(
                            fontFamily: "Brand Blod",
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login_screen()),
                    );
                  },
                )
              ],
            ),
          ))),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registernewuser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: tcemail.text, password: tcpassword.text)
            .catchError((errmsg) {
      Fluttertoast.showToast(msg: "Error: " + errmsg.toString());
    }))
        .user;
    if (firebaseUser != null) {
      userref.child(firebaseUser.uid);
      Map usermap = {
        "name": tcname.text,
        "userid": firebaseUser.uid,
        "usertype": "user",
      };
      userref.child(firebaseUser.uid).set(usermap);
      // Navigator.pushAndRemoveUntil(context, , (route) => false)
      firebaseUser.sendEmailVerification();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login_screen()),
      );
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => main()),);
      //account not created

    }
  }

  void togglePasswordVisibility() => setState(()=> isHidden =! isHidden);
}
