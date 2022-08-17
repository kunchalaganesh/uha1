import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uha1/mainscreens/productionground_page.dart';

import 'allpoints_page.dart';

class production_page extends StatefulWidget {
  static const String routeName = '/production';
  const production_page({Key? key}) : super(key: key);

  @override
  State<production_page> createState() => _production_page();
}

class _production_page extends State<production_page> {
  static const String idScreen = "productionpage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Production"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mproduction.png'),
            fit: BoxFit.fill,
          ),
        ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(top: 150, left: 30, right: 30),
                      child: Column(children: [
                        SizedBox(height: 20.0),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "SATELLITE FIRE ALERTS",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => allpoints_page()),
                            );
                            // showdata();
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "FIRE ALERTS",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => productionground_page()),
                            );
                            // showdata();
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "TWITTER",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => productionground_page()),
                            );
                            // showdata();
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "AIR QUALITY MAPS",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => allpoints_page()),
                            );
                            // showdata();
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "EMERGENCY SERVICES",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => allpoints_page()),
                            );
                            // showdata();
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        ElevatedButton(
                          style:
                          (ElevatedButton.styleFrom(primary: Colors.amber)),
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Mypost",
                                style: TextStyle(
                                    fontFamily: "Brand Blod",
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => allpoints_page()),
                            );
                            // showdata();
                          },
                        ),
                      ])
                  ))
          )
      ),
    );

          // child: Scaffold(
          //
          // ),









  }

}