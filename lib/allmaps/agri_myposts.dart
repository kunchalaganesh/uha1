import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uha1/loginscreens/home_page.dart';
import 'package:uha1/loginscreens/signup_screen.dart';

class agri_myposts extends StatefulWidget {
  const agri_myposts({Key? key}) : super(key: key);

  @override
  State<agri_myposts> createState() => _agri_myposts();
}

class _agri_myposts extends State<agri_myposts> {
  late LatLng currentLatLng = const LatLng(48.8566, 2.3522);
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
    return;
  }

  Future<void> _goToCurrentLocation() async {
    await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 3)));
  }

  Future<void> _getmypositions() async {




  }

  @override
  void initState() {
    super.initState();

    _getmypositions();


    _goToCurrentLocation();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/mregister.png'), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Posts Points'),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: currentLatLng, zoom: 5),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              // markers: <Marker>{
              //   Marker(
              //     draggable: true,
              //     markerId: MarkerId("1"),
              //     position: currentLatLng,
              //     icon: BitmapDescriptor.defaultMarker,
              //     infoWindow: const InfoWindow(
              //       title: 'My Location',
              //     ),
              //   )
              // },
            ),


          ],
        ),
      ),
    );
  }
}
