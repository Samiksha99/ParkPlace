import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:park_place/screens/mainPage.dart';
import '../models/parkingareas.dart';
import '../services/parkingareas.dart';
import '../widgets/parkingcard.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({Key? key}) : super(key: key);

  get list => null;

  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  final googlePlacesKey = "AIzaSyCkKcmYT62_WGyelqflyarQdYpsPSx9_mc";
  String address = "";
  late double latitude, longitude;
  String state = "";
  String country = "";
  int? mobilenumber;
  int? pincode;
  int? twowheels;
  int? fourwheels;
  String ownername = '';
  final TextEditingController _address = TextEditingController();

  Future<void> getOwnerName() {
    return FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .then((value) {
      ownername = value['fullName'];
    });
  }

  CollectionReference users = FirebaseFirestore.instance
      .collection('giveplaceusers')
      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
      .collection('parkingareas');

  Future calculateCoordinates() async {
    List<Location> placemark = await locationFromAddress(address);

    latitude = placemark[0].latitude;
    longitude = placemark[0].longitude;
    print(
      ' COORDINATES: ($latitude, $longitude)',
    );
    print(placemark);
  }

  void addParkingPlaces(String id) async {
    await FirebaseFirestore.instance.collection('parkingPlaces').doc(id).set({
      'max2vehicles': twowheels,
      'max4vehicles': fourwheels,
      'mobileNumber': mobilenumber,
      'ownerNmae': ownername,
      'address': address,
    }).then((val) {
      print("Document successfully written!");
      addGeopoint(id);
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> addGeopoint(String id) async {
    await GeoFirestore(FirebaseFirestore.instance.collection('parkingPlaces'))
        .setLocation(id, GeoPoint(latitude, longitude))
        .then((val) {
      print("Finally Document successfully written!");
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> addplace() async {
    await calculateCoordinates();
    // Call the user's CollectionReference to add a new user
    List<bool> arr = new List<bool>.generate(24, (index) => false);
    return users.add({
      'max2vehicles': twowheels,
      'max4vehicles': fourwheels,
      'mobileNumber': mobilenumber,
      'address': address,
      'lattitude': latitude,
      'longitude': longitude,
      'pincode': pincode,
      'state': state,
      'country': country,
      'timeSlots': arr,
    }).then((value) {
      addParkingPlaces(value.id);
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  List<Parkingareas> allparkingareas = [];
  void initState() {
    super.initState();
    Parkingservices()
        .fetchParkingservices()
        .then((value) => value.forEach((element) {
              setState(() {
                allparkingareas.add(element);
              });
            }));
    getOwnerName();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            'dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MainPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: ElevatedButton(
                    child: Text("Add Place"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            elevation: 16,
                            child: Container(
                              height: 600.0,
                              width: 400.0,
                              child: ListView(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      "Register Place",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Address',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: TextFormField(
                                        onChanged: (text) {
                                          address = text;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter an address';
                                          }
                                          return null;
                                        },
                                      )
                                      // child:TextFormField(
                                      //   decoration: new InputDecoration(
                                      //     border: InputBorder.none,
                                      //     contentPadding: EdgeInsets.only(left: 15),
                                      //     hintText: 'Address',
                                      //   ),
                                      //   maxLines: 1,
                                      //   // controller: _address,
                                      //   onTap: ()async{
                                      //     // then get the Prediction selected
                                      //     Prediction p = await PlacesAutocomplete.show(
                                      //       context: context,
                                      //       apiKey: googlePlacesKey,
                                      //       mode: Mode.overlay, // Mode.fullscreen
                                      //       language: "fr",
                                      //       components: [new Component(Component.country, "fr")]);

                                      //     displayPrediction(p);
                                      //   },
                                      // )
                                      ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Pincode',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          pincode = int.parse(text);
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a valid pincode';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'State',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        onChanged: (text) {
                                          state = text;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a state';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Number of two whellers',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          twowheels = int.parse(text);
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a number';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Number of four wheelers',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          fourwheels = int.parse(text);
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a number';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Country',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        onChanged: (text) {
                                          country = text;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a country name';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Contact Number',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        onChanged: (text) {
                                          mobilenumber = int.parse(text);
                                        },
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please enter a valid mobile number';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 0.0),
                                    child: Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 30),
                                      child: (TextFormField(
                                        key: ValueKey('email'),
                                        validator: (value) {
                                          if (value == null ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ))),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          30.0, 5.0, 30.0, 40.0),
                                      child: ElevatedButton(
                                        child: Text('Submit'),
                                        onPressed: addplace,
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green[600],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    })),
            Container(
              height: 500,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allparkingareas.length,
                  itemBuilder: (context, index) {
                    return ParkingCard(
                      parkingareas: allparkingareas[index],
                    );
                  }),
            )
          ]),
        ));
  }
}
