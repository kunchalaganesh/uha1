import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  final TextEditingController _lat = TextEditingController();
  final TextEditingController _lng = TextEditingController();
  late String selectedCurrency;
  late final Firestore firestore;
  late String dropdownValue = 'choose';
  late String slat, slng;
  late final List<String> val = ['c', 'Dog', 'choose'];
  final List<spinnermodel> sp1 = [];
  String hintValue = 'Tout de Suite';
  var keys, data;

  String? agrifuel, agriundestory, agridistance;
  Stream<QuerySnapshot>? agrifuelspinner,
      agriundestoryspinner,
      agridistancespinner;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();


  Future imgFromGallery() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }


  @override
  void initState() {
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                        child: new TextField(
                          controller: _lat,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "",
                          ),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: new Text("Longitude"),
                        flex: 1,
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: _lng,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "",
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: (ElevatedButton.styleFrom(primary: Colors.black)),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => get_location()),
                      );
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
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: agrifuelspinner,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return DropdownButton(
                                    value: agrifuel,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    hint: const Text("Choose Fuel Type"),
                                    // Array list of items
                                    items: snapshot.data?.docs.map((govData) {
                                      return DropdownMenuItem(
                                        value: govData.id,
                                        child: Text(govData.id),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          agrifuel = value!;
                                        },
                                      );
                                    },
                                  );
                                }),

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
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: agriundestoryspinner,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return DropdownButton(
                                    value: agriundestory,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    hint: const Text("Choose Undestory"),
                                    // Array list of items
                                    items: snapshot.data?.docs.map((govData) {
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
                            child: Text('Height Fuel'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              color: Colors.white, child: TextField()),
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
                              color: Colors.white, child: TextField()),
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
                          child: StreamBuilder<QuerySnapshot>(
                              stream: agridistancespinner,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return DropdownButton(
                                  value: agridistance,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: const Text("Choose Distance"),
                                  // Array list of items
                                  items: snapshot.data?.docs.map((govData) {
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(color: Colors.red[200]),
                        child: _photo != null
                            ? Image.file(
                                _photo!,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: Colors.red[200]),
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
                    height: 5.0,
                  ),
                  Text(
                    "Upload Image",
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
                              color: Colors.white, child: TextField()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    style: (ElevatedButton.styleFrom(primary: Colors.black)),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => get_location()),
                      );
                      // showdata();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ]))));
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
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }
                    ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: ()  {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          );
        });
  }

  get_location() {}

  upload() {}
}



class Row2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.orange,
      height: 48,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.white,
                child: Text('LIVhdhgvhjdkghgvhjdfhbdbbhbbvdnmbvsdbvhjbdhfhbE'),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: Colors.white,
                child: Text(
                    '\$ 8kjldhlkhkjhkjlhdkjsdjfhjgfdgshfjgskglggksgkjshgfdg0'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
