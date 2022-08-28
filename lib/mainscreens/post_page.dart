
import 'package:flutter/material.dart';
import 'package:uha1/mainscreens/postground_page.dart';
import 'package:uha1/mainscreens/productionground_page.dart';

import 'allpoints_page.dart';

class post_page extends StatefulWidget {
  static const String routeName = '/agripage';
  const post_page({Key? key}) : super(key: key);

  @override
  State<post_page> createState() => _post_page();
}

class _post_page extends State<post_page> {
  static const String idScreen = "postpage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
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
                                "AREA MAP",
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
                                "DAMAGE",
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
                                  builder: (context) => postground_page()),
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
                                "MYPOST",
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

                      ])
                  ))
          )
      ),
    );

  }

}