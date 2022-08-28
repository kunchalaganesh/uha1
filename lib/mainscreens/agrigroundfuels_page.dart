import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uha1/mainscreens/agri_page.dart';
import 'package:uuid/uuid.dart';

import '../models/spinnermodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class agrigroundfuels_page extends StatefulWidget {
  static const String routeName = '/agrigroundfuelspage';

  const agrigroundfuels_page({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _agrigroundfuels_page();
}

class _agrigroundfuels_page extends State<agrigroundfuels_page> {
  final TextEditingController efhight = TextEditingController();
  final TextEditingController euhight = TextEditingController();
  final TextEditingController eobv = TextEditingController();

  late String selectedCurrency;
  late final Firestore firestore;
  late String dropdownValue = 'choose';
  late String slat = ""; //
  late String slng = "";
  late final List<String> val = ['c', 'Dog', 'choose'];
  final List<spinnermodel> sp1 = [];
  String hintValue = 'Tout de Suite';
  var keys, data;
  bool evisible = true;
  bool vvisible = false;
  String imageurl = "";
  String ownername = "";
  final dbref = FirebaseDatabase.instance.reference();

  String? agrifuel, agriundestory, agridistance;
  Stream<QuerySnapshot>? agrifuelspinner,
      agriundestoryspinner,
      agridistancespinner;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(context) async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        progressDialogue(context);
        uploadFile(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(context) async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        progressDialogue(context);
        uploadFile(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(context1) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';


    try {



      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      // ref.getDownloadURL();
      imageurl = (await ref.getDownloadURL()).toString();
      // setState(() async {
      //   imageurl = (await ref.getDownloadURL()).toString();
      // });
      if(imageurl!= null){
        Navigator.pop(context1);
      }

      print('this is url ' + imageurl);
    } catch (e) {
      print('error occured');
      Navigator.pop(context1);
      toastshow(e.toString());

    }
  }

  Future readowner() async {
    final dref = FirebaseDatabase.instance.reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
    .child("name");

    setState(() async {
      ownername = (await dref.once()).value;
    });

  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      slat = position.latitude.toString();
      slng = position.longitude.toString();
    });
  }

  void writedata() async {
    if (slat == "") {
      toastshow("Failed to fetch location please click get location");
    } else if (slng == "") {
      toastshow("Failed to fetch location please click get location");
    } else if (agrifuel == null) {
      toastshow("Please choose fuel type");
    } else if (agriundestory == null) {
      toastshow("Please choose undestory");
    } else if (efhight.text.isEmpty) {
      toastshow("Please enter Height fuel");
    } else if (euhight.text.isEmpty) {
      toastshow("Please enter Height undestory");
    } else if (agridistance == null) {
      toastshow("Please choose distance");
    } else if (imageurl == "") {
      toastshow("Failed to upload image");
    } else if (eobv.text.isEmpty) {
      toastshow("Please enter Observation");
    } else {
      readowner();
      setState(() {
        vvisible = true;
        evisible = false;
      });
    }
  }

  progressDialogue(BuildContext context) {
    //set up the AlertDialog
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
      //prevent outside touch
      barrierDismissible: false,
      context:context, builder: (BuildContext context) {

      return ElevatedButton(
        onPressed: () {
          Fluttertoast.showToast(msg: "Uploading Please Wait", toastLength: Toast.LENGTH_SHORT);
          // Navigator.of(context).pop(false);
        },
        child: new Text('Upload Image Please Wait'),
      );
    },
      // builder: (BuildContext context) {
      //   //prevent Back button press
      //   return WillPopScope(
      //       onWillPop: (){
      //       },
      //       child: alert);
      // },
    );
  }

  Future<bool> getalldata() async{
    bool success = false;
    try{

      var now = new DateTime.now();
      var formatter = new DateFormat('ddMyyy');
      String formattedDate = formatter.format(now);
      print(formattedDate);

      String id = Uuid().v1().toString();
      String currenttime = new DateTime.now().millisecondsSinceEpoch.toString();
      var sdf = new DateFormat('dd/MM/yyy HH:mm:ss');//SimpleDateFormat("dd/MM/yyy_HH:mm:ss", Locale.getDefault());
      String currentDateandTime = sdf.format(now);

      await dbref.child("alldata").child(formattedDate)
          .child(id).set(
          {'date': currentDateandTime,
            'lattitude': slat,
            'longitude': slng,
            'main1': agrifuel,
            'main2': agriundestory,
            'main1height': efhight.text.toString(),
            'main2height' :euhight.text.toString(),
            'distance' : agridistance,
            'obv': eobv.text.toString(),
            'nimage': imageurl,
            'ground': 'agri',
            'id': id,
            'owner': ownername,
            'posteddate': currentDateandTime
          }
      );

      success = true;
    }catch(e){
      success = false;

    }

    return success;
  }


  void toastshow(mes) async {
    Fluttertoast.showToast(msg: mes, toastLength: Toast.LENGTH_SHORT);
  }



  @override
  void initState() {

    getLocation();

    agrifuelspinner =
        FirebaseFirestore.instance.collection("agrifuelspinner").snapshots();
    agriundestoryspinner = FirebaseFirestore.instance
        .collection("agriundestoryspinner")
        .snapshots();
    agridistancespinner = FirebaseFirestore.instance
        .collection("agridistancespinner")
        .snapshots();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/magri.png'), fit: BoxFit.cover)),

      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Visibility(
                      visible: evisible,
                      child: SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                              child: Column(children: [
                                Text('Ground fuels',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 30.0, fontWeight: FontWeight.bold)),
                                SizedBox(height: 20.0),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new Text("Latitude"),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.red),
                                        ),
                                        child: new TextField(
                                          enabled: false,
                                          keyboardType: TextInputType.text,
                                          style: new TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: slat,
                                            labelStyle:
                                            TextStyle(color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: new Text("Longitude"),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.red),
                                        ),
                                        child: new TextField(
                                          enabled: false,
                                          keyboardType: TextInputType.text,
                                          style: new TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: slng,
                                            labelStyle:
                                            TextStyle(color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: (ElevatedButton.styleFrom(
                                      primary: Colors.black)),
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Get Location",
                                        style: TextStyle(
                                            fontFamily: "Brand Blod",
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    getLocation();
                                    // showdata();
                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Fuel Type Main'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            width: double.infinity,
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: StreamBuilder<QuerySnapshot>(
                                                  stream: agrifuelspinner,
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                    return DropdownButton(
                                                      value: agrifuel,

                                                      style: new TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17),
                                                      // Down Arrow Icon
                                                      icon: const Icon(
                                                          Icons.keyboard_arrow_down),
                                                      hint: const Text(
                                                          "Choose Fuel Type"),
                                                      // Array list of items
                                                      items: snapshot.data?.docs
                                                          .map((govData) {
                                                        return DropdownMenuItem(
                                                          value: govData.id,
                                                          child: Text(govData.id),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        // style: new TextStyle(color: Colors.black)
                                                        setState(
                                                              () {
                                                            agrifuel = value!;
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }),
                                            )

                                          //here need to remove
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Undestory Main'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            width: double.infinity,
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: StreamBuilder<QuerySnapshot>(
                                                  stream: agriundestoryspinner,
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                    return DropdownButton(
                                                      value: agriundestory,
                                                      // Down Arrow Icon
                                                      icon: const Icon(
                                                          Icons.keyboard_arrow_down),
                                                      hint: const Text(
                                                          "Choose Undestory"),
                                                      // Array list of items
                                                      items: snapshot.data?.docs
                                                          .map((govData) {
                                                        return DropdownMenuItem(
                                                          value: govData.id,
                                                          child: Text(govData.id),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        setState(
                                                              () {
                                                            agriundestory = value!;
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Height Fuel'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: TextField(
                                              controller: efhight,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Enter fuel height"),
                                              textAlign: TextAlign.center,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Height Undestory'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText:
                                                  "Enter undestory height"),
                                              controller: euhight,
                                              textAlign: TextAlign.center,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Distance'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            width: double.infinity,
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: StreamBuilder<QuerySnapshot>(
                                                  stream: agridistancespinner,
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                    return DropdownButton(
                                                      value: agridistance,
                                                      // Down Arrow Icon
                                                      icon: const Icon(
                                                          Icons.keyboard_arrow_down),
                                                      hint: const Text(
                                                          "Choose Distance"),
                                                      // Array list of items
                                                      items: snapshot.data?.docs
                                                          .map((govData) {
                                                        return DropdownMenuItem(
                                                          value: govData.id,
                                                          child: Text(govData.id),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        setState(
                                                              () {
                                                            agridistance = value!;
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  height: 150.0,
                                  width: 100.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context);
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration:
                                      BoxDecoration(color: Colors.red[200]),
                                      child: _photo != null
                                          ? Image.file(
                                        _photo!,
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.fitHeight,
                                      )
                                          : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red[200]),
                                        width: 200,
                                        height: 200,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Click on Camera Icon To Upload Image",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                          child: Text('Observation'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            width: double.infinity,
                                            padding:
                                            EdgeInsets.fromLTRB(10, 2, 10, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: TextField(
                                              controller: eobv,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Enter Observation"),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                ElevatedButton(
                                  style: (ElevatedButton.styleFrom(
                                      primary: Colors.black)),
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontFamily: "Brand Blod",
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    writedata();
                                    // setState(
                                    //     (){
                                    //       evisible = false;
                                    //       vvisible = true;
                                    //     }
                                    // );
                                    // showdata();
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                )
                              ]))),
                    ),
                    Visibility(
                        visible: vvisible,
                        child: SingleChildScrollView(
                            child: Padding(
                                padding:
                                EdgeInsets.only(top: 80, left: 20, right: 20),
                                child: Column(children: [
                                  Text('Ground fuels Entries',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Latitude',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: slat,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Longitude',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: slng,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Fuel Type Main',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: agrifuel,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Undestory Main',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: agriundestory,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Height Fuel',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: efhight.text,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Height Undestory',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: euhight.text,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Distance',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: agridistance,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  new Text(
                                    "Uploaded Image",
                                    style:
                                    TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: _photo != null
                                        ? Image.file(
                                      _photo!,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.fitHeight,
                                    )
                                        : Container(
                                      decoration:
                                      BoxDecoration(color: Colors.white),
                                      width: 200,
                                      height: 200,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            color: Colors.white,
                                            child: Text(
                                              'Observation',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.red),
                                            ),
                                            child: new TextField(
                                              keyboardType: TextInputType.text,
                                              style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: eobv.text,
                                                  labelStyle:
                                                  TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    alignment: FractionalOffset.center,
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () async {


                                              final s1 = await getalldata();
                                              if(s1){

                                                try{

                                                  var now = new DateTime.now();
                                                  var formatter = new DateFormat('ddMyyy');
                                                  String formattedDate = formatter.format(now);
                                                  print(formattedDate);

                                                  String id = Uuid().v1().toString();
                                                  String currenttime = new DateTime.now().millisecondsSinceEpoch.toString();
                                                  var sdf = new DateFormat('dd/MM/yyy HH:mm:ss');//SimpleDateFormat("dd/MM/yyy_HH:mm:ss", Locale.getDefault());
                                                  String currentDateandTime = sdf.format(now);

                                                  dbref.child("mydata").child(FirebaseAuth.instance.currentUser.uid)
                                                      .child("agri")
                                                      .child(id).set(
                                                      {
                                                    'date': id,
                                                    'lattitude': slat,
                                                    'longitude': slng,
                                                    'main1': agrifuel,
                                                    'main2': agriundestory,
                                                    'main1height': efhight.text,
                                                    'main2height' :euhight.text,
                                                    'distance' : agridistance,
                                                    'obv': eobv.text,
                                                    'nimage': imageurl,
                                                    'ground': 'agri',
                                                    'id': id,
                                                    'owner': ownername,
                                                    'posteddate': currentDateandTime
                                                  });

                                                  try{
                                                    dbref.child("agridata")
                                                        .child(id)
                                                        .set(
                                                        {'date': id,
                                                          'lattitude': slat,
                                                          'longitude': slng,
                                                          'main1': agrifuel,
                                                          'main2': agriundestory,
                                                          'main1height': efhight.text,
                                                          'main2height' :euhight.text,
                                                          'distance' : agridistance,
                                                          'obv': eobv.text,
                                                          'nimage': imageurl,
                                                          'ground': 'agri',
                                                          'id': id,
                                                          'owner': ownername,
                                                          'posteddate': currentDateandTime
                                                        }
                                                    );

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => agri_page()),
                                                    );


                                                  }catch(e){
                                                    print("errorr1"+ e.toString());

                                                  }
                                                  catch(e){
                                                    print("errorr2"+ e.toString());
                                                  }

                                                }catch(e){
                                                  print("errorr2"+ e.toString());
                                                }


                                              }
















                                              // FirebaseDatabase.getInstance().getReference().child("mydata").child(FirebaseAuth.getInstance().getUid()).child("agri")
                                              //     .child(id).setValue(data);
                                              // FirebaseDatabase.getInstance().getReference().child("agridata").child(id)
                                              //     .setValue(data).addOnCompleteListener(new OnCompleteListener<Void>() {
                                              // @Override
                                              // public void onComplete(@NonNull Task<Void> task) {
                                              // if (task.isSuccessful()) {
                                              // Toast.makeText(groundactivity.this, "Saved", Toast.LENGTH_SHORT).show();
                                              // finish();
                                              // }
                                              // }









                                            },



                                            child: new Text('Save',
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: ElevatedButton(
                                            child: new Text(
                                              'Edit',
                                              style: new TextStyle(
                                                  color: Colors.black, fontSize: 18),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                vvisible = false;
                                                evisible = true;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]))))
                  ],
                ),
              ))),



    );



  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imgFromCamera(context);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }
}
