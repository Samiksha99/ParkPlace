import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:park_place/screens/location_page.dart';
import 'package:park_place/screens/mainPage.dart';
import 'package:park_place/screens/parkVehivleHomePage.dart';

class ParkDetailsScreen extends StatefulWidget {
  @override
  _ParkDetailsScreenState createState() => _ParkDetailsScreenState();
}

class _ParkDetailsScreenState extends State<ParkDetailsScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  void showSnackBar(String msg, Color color) {
    var snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  late String name;
  bool saving = false;

  void _saveInfo() async {
    await FirebaseFirestore.instance
        .collection("parkvehicleusers")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .update({
      'fullName': name,
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => ParkVehicleHome(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showSnackBar('You cannot go back at this stage ', Colors.grey[600]!);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text('User Details'),
          ),
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
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your Details.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "Enter the corresponding details to continue...",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formkey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(.5),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.35),
                        ),
                      ),
                      validator: (val) {
                        setState(() {
                          name = val!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // _selectStore(context),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //shadowColor: Colors.white38,
                        primary: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: saving
                          ? () {}
                          : () {
                              FocusScope.of(context).unfocus();
                              _formkey.currentState!.validate();
                              if (name.isNotEmpty) {
                                setState(() {
                                  saving = true;
                                });
                                _saveInfo();
                              } else {
                                showSnackBar('Please enter valid inforamtion',
                                    Colors.red);
                              }
                            },
                      child: saving
                          ? SpinKitFadingCircle(
                              color: Colors.black54,
                              size: 20,
                            )
                          : Container(
                              width: 120,
                              child: Center(
                                child: Text(
                                  "Save and Continue",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
