import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uha1/loginscreens/home_page.dart';
import 'package:uha1/loginscreens/signup_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screen();
}

class _login_screen extends State<login_screen> {
  TextEditingController tcemail = TextEditingController();
  TextEditingController tcpassword = TextEditingController();
  static const String idScreen = "loginscreen";
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
                  height: 20,
                ),
                ElevatedButton(
                  style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontFamily: "Brand Blod",
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (tcemail.text.isEmpty || !tcemail.text.contains("@")) {
                      Fluttertoast.showToast(msg: "Enter correct email");
                    } else if (tcpassword.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Password");
                    } else {
                      checkuser(context);
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
                        "Register New Account",
                        style: TextStyle(
                            fontFamily: "Brand Blod",
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signup_screen()),
                    );
                  },
                )
              ],
            ),
          ))),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void checkuser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: tcemail.text, password: tcpassword.text)
            .catchError((errmsg) {
      Fluttertoast.showToast(msg: "Error: " + errmsg.toString());
    }))
        .user;
    if (firebaseUser != null) {
      if (firebaseUser.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home_page()),
        );
      } else {
        firebaseUser.sendEmailVerification();
        Fluttertoast.showToast(msg: "Error: " + "Please Verify EmailID");
      }
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => main()),);
      //account not created

    }
  }

  void togglePasswordVisibility() => setState(()=> isHidden =! isHidden);
}
