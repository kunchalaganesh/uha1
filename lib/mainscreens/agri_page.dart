import 'package:flutter/material.dart';
import 'package:uha1/mainscreens/productionground_page.dart';

import 'agrigroundfuels_page.dart';
import 'allpoints_page.dart';

class agri_page extends StatefulWidget {
  static const String routeName = '/agripage';

  const agri_page({Key? key}) : super(key: key);

  @override
  State<agri_page> createState() => _agri_page();
}

class _agri_page extends State<agri_page> {
  static const String idScreen = "agripage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agri")),
      body: Center(
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
                                "INDEX",
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
                                "WEATHER PARAMETERS",
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
                                "GROUND FUELS",
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
                                  builder: (context) => agrigroundfuels_page()),
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
                                "FUEL TYPE MAP",
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
                                "PROPAGATION",
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
                      ]))))),
    );
  }
}
