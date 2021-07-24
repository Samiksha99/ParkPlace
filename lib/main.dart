import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'Location/location_page.dart';
import 'package:park_place/screens/Home.dart';
import 'package:park_place/screens/HomeUser.dart';
import 'package:park_place/screens/detailsScreen.dart';
import 'package:park_place/screens/location_page.dart';
import 'package:park_place/screens/mainPage.dart';
import 'package:park_place/screens/parkVehivleHomePage.dart';
import 'package:park_place/screens/parkvehicleDetailPage.dart';
import 'package:park_place/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

bool owner = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkRole();
    super.initState();
  }

  Future<void> checkRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    owner = (pref.getBool('ownerRole') ?? false);
  }

  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/detailsScreen': (context) => DetailsScreen(),
            '/mainPage': (context) => MainPage(),
          },
          // home: OTPScreen(),
          home: snapshot.connectionState != ConnectionState.done
              ? Loading()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      log('Loading');
                      return Loading();
                    } else if (owner) {
                      if (userSnapshot.data != null) {
                        log('Logged in');
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("giveplaceusers")
                              .doc(FirebaseAuth
                                  .instance.currentUser!.phoneNumber)
                              .snapshots(),
                          builder: (context, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return Loading();
                            } else {
                              if (snapShot.hasData) {
                                return Home();
                                // }
                              }
                              log('Has no data');
                              return DetailsScreen();
                            }
                          },
                        );
                      }
                    } else if (!owner) {
                      if (userSnapshot.data != null) {
                        log('Logged in');
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("parkvehicleusers")
                              .doc(FirebaseAuth
                                  .instance.currentUser!.phoneNumber)
                              .snapshots(),
                          builder: (context, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return Loading();
                            } else {
                              if (snapShot.hasData) {
                                return HomeUser();
                                // }
                              }
                              log('Has no data');
                              return ParkDetailsScreen();
                            }
                          },
                        );
                      }
                    }
                    log('UserSnapshot = null');
                    return MainPage();
                  },
                ),
        );
      },
    );
  }
}
