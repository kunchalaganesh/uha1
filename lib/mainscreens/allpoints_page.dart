import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class allpoints_page extends StatefulWidget {
  const allpoints_page({Key? key}) : super(key: key);

  @override
  State<allpoints_page> createState() => _allpoints_page();
}

class _allpoints_page extends State<allpoints_page> {
  late GoogleMapController mapController;

  // = const LatLng(45.521563, -122.677433);
  final dref = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;
  // late final LatLng _center;
  late final Position _currentPosition;
  // late final LatLng _center ;// = const LatLng(45.521563, -122.677433);
  LatLng _center= const LatLng(45.521563, -122.677433);

  // getUserLocation();
  showdata() {
    dref
        .child("alldata")
        .child("2252022")
        .child("1036af02-fe6d-4072-b01b-2af273e65eb2");
    dref.once().then((snapshot) {
      print(snapshot.value);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    // _center = const LatLng(_currentPosition.latitude, _currentPosition.longitude);
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('All Posts Points'),
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
        ),
      );


  }

  void _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        double lat = _currentPosition.latitude;
        double lng = _currentPosition.longitude;


        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        );

        // _center = const LatLng(lat.toDouble(), lng.toDouble());
        print("mylocation"+lat.toString() +"  "+lng.toString());
      });
    }).catchError((e) {
      print(e);
    });
  }
}
