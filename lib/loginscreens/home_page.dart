import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uha1/loginscreens/login_screen.dart';
import 'package:uha1/mainscreens/agri_page.dart';
import 'package:uha1/mainscreens/allpoints_page.dart';
import 'package:uha1/mainscreens/post_page.dart';
import 'package:uha1/mainscreens/production_page.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  static const String idScreen = "homepage";
  int selectedindex = 0;

  late final dref = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;
  late GoogleMapController mapController;

  showdata() {
    databaseReference = dref
        .child("alldata")
        .child("2252022")
        .child("1036af02-fe6d-4072-b01b-2af273e65eb2");
    databaseReference.once().then((snapshot) {
      print("myvalue  " + snapshot.value);
    });
  }

  LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          height: 1000, // This line solved the issue
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ), // Mapbox
        ),
        new Container(
          alignment: Alignment.center,
          child: Scaffold(
              drawer: NavigationDrwer(),
              appBar: AppBar(
                title: Text("HOME"),
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.only( left: 30, right: 30),
                // padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    // Image(
                    //   image: AssetImage("assets/logo.jpeg"),
                    //   width: 150,
                    //   height: 150,
                    // ),
                    SizedBox(
                      height: 3.0,
                    ),
                    ElevatedButton(
                      style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "All Points",
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
                      style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Agri",
                            style: TextStyle(
                                fontFamily: "Brand Blod",
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => agri_page()),
                        );
                        // showdata();
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    ElevatedButton(
                      style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Production",
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
                              builder: (context) => production_page()),
                        );
                        // showdata();
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    ElevatedButton(
                      style: (ElevatedButton.styleFrom(primary: Colors.amber)),
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontFamily: "Brand Blod",
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => post_page()),
                        );
                        // showdata();
                      },
                    ),
                  ],
                ),
              ))),
        ),
      ],
    );
  }
}

class NavigationDrwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(50, 70, 205, 1),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            buildmenuItem(
              text: "About",
              icon: Icons.account_balance,
              onClicked: () => selecteditem(context, 1),
            ),
            Divider(color: Colors.white),
            const SizedBox(
              height: 10,
            ),
            buildmenuItem(
              text: "home",
              icon: Icons.account_balance,
              onClicked: () => selecteditem(context, 0),
            ),
            const SizedBox(height: 10),
            buildmenuItem(
              text: "agri",
              icon: Icons.account_balance,
              onClicked: () => selecteditem(context, 1),
            ),
            const SizedBox(height: 10),
            buildmenuItem(
              text: "Porduction",
              icon: Icons.account_balance,
              onClicked: () => selecteditem(context, 2),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white),
            const SizedBox(height: 10),
            buildmenuItem(
              text: "Logout",
              icon: Icons.logout,
              onClicked: () => selecteditem(context, 3),
            ),
          ],
        ),
      ),
    );
  }

  buildmenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    final color = Colors.white;
    final hovercolor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hovercolor,
      onTap: onClicked,
    );
  }

  selecteditem(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => home_page()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => agri_page()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => production_page()),
        );
        break;
      case 3:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => login_screen()),
        );

        break;
    }
  }
}
