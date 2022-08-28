
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:uha1/mainscreens/post_page.dart';
import 'package:uuid/uuid.dart';




class postground_page extends StatefulWidget {
  static const String routeName = '/agripage';
  const postground_page({Key? key}) : super(key: key);

  @override
  State<postground_page> createState() => _postground_page();
}

class _postground_page extends State<postground_page> {
  late String slat = ""; //
  late String slng = "";
  bool evisible = true;
  bool vvisible = false;
  String northimage = "";
  String southimage = "";
  String eastimage = "";
  String westimage = "";
  String ownername = "";
  final TextEditingController eobv = TextEditingController();

  bool north = false;
  bool south = false;
  bool east = false;
  bool west = false;

  final dbref = FirebaseDatabase.instance.reference();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocation();
  }



  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo, _nphoto, _sphoto, _wphoto, _ephoto;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(context) async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        if(north){
          _nphoto = _photo;
        }
        if(south){
          _sphoto = _photo;
        }
        if(west){
          _wphoto = _photo;

        }
        if(east){
          _ephoto = _photo;
        }

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
        if(north){
          _nphoto = _photo;
        }
        if(south){
          _sphoto = _photo;
        }
        if(west){
          _wphoto = _photo;

        }
        if(east){
          _ephoto = _photo;
        }
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

      if(north){
        northimage = (await ref.getDownloadURL()).toString();
      }

      if(south){
        southimage = (await ref.getDownloadURL()).toString();
        if(southimage!= null){
          Navigator.pop(context1);
        }
      }
      if(west){
        westimage = (await ref.getDownloadURL()).toString();
        if(westimage!= null){
          Navigator.pop(context1);
        }
      }
      if(east){
        eastimage = (await ref.getDownloadURL()).toString();
        if(eastimage!= null){
          Navigator.pop(context1);
        }
      }

      if(north == true && northimage!= null){
        Navigator.pop(context1);
      }

      // setState(() async {
      //   imageurl = (await ref.getDownloadURL()).toString();
      // });


      // print('this is url ' + imageurl);
    } catch (e) {
      print('error occured');
      Navigator.pop(context1);
      toastshow(e.toString());

    }
  }

  void writedata() async {
    if (slat == "") {
      toastshow("Failed to fetch location please click get location");
    } else if (slng == "") {
      toastshow("Failed to fetch location please click get location");
    } else if (northimage == "") {
      toastshow("Failed to Upload Image 1");
    } else if (southimage == "") {
      toastshow("Failed to Upload Image 2");
    } else if (westimage == "") {
      toastshow("Failed to upload image 3");
    }else if(eastimage == ""){
      toastshow("Failed to Upload Image 4");

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


  Future readowner() async {
    final dref = FirebaseDatabase.instance.reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("name");

    setState(() async {
      ownername = (await dref.once()).value;
    });

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

  void toastshow(mes) async {
    Fluttertoast.showToast(msg: mes, toastLength: Toast.LENGTH_SHORT);
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container (
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


                                new Column(

                                  children: <Widget>[

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[


                                        Column(

                                          children: <Widget>[
                                            SizedBox(
                                              height: 150.0,
                                              width: 100.0,
                                              child: GestureDetector(
                                                onTap: () {

                                                  north = true;
                                                  south = false;
                                                  west = false;
                                                  east = false;
                                                  _showPicker(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration:
                                                  BoxDecoration(color: Colors.red[200]),
                                                  child: _nphoto != null
                                                      ? Image.file(
                                                    _nphoto!,
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
                                              height: 10,
                                            ),

                                            Text("Image 1")

                                          ],

                                        ),

                                        Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 150.0,
                                              width: 100.0,
                                              child: GestureDetector(
                                                onTap: () {

                                                  north = false;
                                                  south = true;
                                                  west = false;
                                                  east = false;


                                                  _showPicker(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration:
                                                  BoxDecoration(color: Colors.red[200]),
                                                  child: _sphoto != null
                                                      ? Image.file(
                                                    _sphoto!,
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
                                            SizedBox(height: 10,),
                                            Text("Image 2")


                                          ],

                                        )





                                      ],



                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[

                                        Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 150.0,
                                              width: 100.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  north = false;
                                                  south = false;
                                                  west = true;
                                                  east = false;
                                                  _showPicker(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration:
                                                  BoxDecoration(color: Colors.red[200]),
                                                  child: _wphoto != null
                                                      ? Image.file(
                                                    _wphoto!,
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
                                              height: 10,
                                            ),
                                            Text("Image 3")
                                          ],

                                        ),

                                        Column(
                                          children: <Widget>[

                                            SizedBox(
                                              height: 150.0,
                                              width: 100.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  north = false;
                                                  south = false;
                                                  west = false;
                                                  east = true;
                                                  _showPicker(context);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration:
                                                  BoxDecoration(color: Colors.red[200]),
                                                  child: _ephoto != null
                                                      ? Image.file(
                                                    _ephoto!,
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
                                              height: 10,
                                            ),

                                            Text("Image 4" )



                                          ],
                                        ),





                                      ],

                                    ),

                                  ],

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
                                          child: Text('Description'),
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
                                  Text('Ground Post Entries',
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

                                  new Text(
                                    "Uploaded Images",
                                    style:
                                    TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                                  SizedBox(height: 10.0),

                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,

                                    child: Column(
                                      children: <Widget>[

                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(color: Colors.transparent),
                                              child: _nphoto != null
                                                  ? Image.file(
                                                _nphoto!,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.fitHeight,
                                              )
                                                  : Container(
                                                decoration:
                                                BoxDecoration(color: Colors.transparent),
                                                width: 200,
                                                height: 200,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(color: Colors.transparent),
                                              child: _sphoto != null
                                                  ? Image.file(
                                                _sphoto!,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.fitHeight,
                                              )
                                                  : Container(
                                                decoration:
                                                BoxDecoration(color: Colors.transparent),
                                                width: 200,
                                                height: 200,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),



                                          ],
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),

                                        new Row(


                                          children: <Widget>[

                                            Container(


                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(color: Colors.transparent),
                                              child: _wphoto != null
                                                  ? Image.file(
                                                _wphoto!,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.fitHeight,
                                              )
                                                  : Container(
                                                decoration:
                                                BoxDecoration(color: Colors.transparent),
                                                width: 200,
                                                height: 200,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),


                                            Container(


                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(color: Colors.transparent),
                                              child: _ephoto != null
                                                  ? Image.file(
                                                _ephoto!,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.fitHeight,
                                              )
                                                  : Container(
                                                decoration:
                                                BoxDecoration(color: Colors.transparent),
                                                width: 200,
                                                height: 200,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),


                                          ],






                                        ),

                                      ],

                                    )


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
                                                      .child("post")
                                                      .child(id).set(
                                                      {
                                                        'date': formattedDate,
                                                        'lattitude': slat,
                                                        'longitude': slng,
                                                        'descrption': eobv.text,
                                                        'nimage': northimage,
                                                        'ground': "post",
                                                        'simage' : southimage,
                                                        'wimage': westimage,
                                                        'nimage': northimage,
                                                        'eimage': eastimage,
                                                        'id': id,
                                                        'owner': ownername,
                                                        'posteddate': currentDateandTime
                                                      });

                                                  try{
                                                    dbref.child("postdata")
                                                        .child(id)
                                                        .set(
                                                        {
                                                          'date': formattedDate,
                                                          'lattitude': slat,
                                                          'longitude': slng,
                                                          'descrption': eobv.text,
                                                          'nimage': northimage,
                                                          'ground': "post",
                                                          'simage' : southimage,
                                                          'wimage': westimage,
                                                          'nimage': northimage,
                                                          'eimage': eastimage,
                                                          'id': id,
                                                          'owner': ownername,
                                                          'posteddate': currentDateandTime
                                                        }
                                                    );

                                                    try {

                                                      dbref.child("alldata")
                                                      .child(formattedDate)
                                                      .child(id)
                                                      .set(
                                                          {
                                                            'date': formattedDate,
                                                            'lattitude': slat,
                                                            'longitude': slng,
                                                            'descrption': eobv.text,
                                                            'nimage': northimage,
                                                            'ground': "post",
                                                            'simage' : southimage,
                                                            'wimage': westimage,
                                                            'nimage': northimage,
                                                            'eimage': eastimage,
                                                            'id': id,
                                                            'owner': ownername,
                                                            'posteddate': currentDateandTime

                                                          }
                                                      );


                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                post_page()),
                                                      );
                                                    }catch(e){


                                                    }


                                                  }catch(e){
                                                    print("errorr1"+ e.toString());

                                                  }
                                                  catch(e){
                                                    print("errorr2"+ e.toString());
                                                  }

                                                }catch(e){
                                                  print("errorr2"+ e.toString());
                                                }





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