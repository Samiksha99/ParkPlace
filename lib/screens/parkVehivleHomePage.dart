import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:park_please/models/locations.dart';
import 'package:park_please/screens/mainPage.dart';
import 'package:park_please/services/locations.dart';
import 'package:park_please/widgets/locations_card.dart';

class ParkVehicleHome extends StatefulWidget {
  const ParkVehicleHome({ Key? key }) : super(key: key);

  @override
  _ParkVehicleHomeState createState() => _ParkVehicleHomeState();
}

class _ParkVehicleHomeState extends State<ParkVehicleHome> {



  List<Locations> parkingLocations=[];
  @override
  void initState(){
    // getParkingAreas();
    super.initState();
    Locationservices()
      .fetchLocationservices()
      .then((value) => value.forEach((element) {
        setState(() {
          parkingLocations.add(element);
        });
      }));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.pink[700],
          title: Text('Welcome Page',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainPage(),
                ),
                (route) => false,
              );
            }, icon: Icon(Icons.logout)),
          ],
        ),
        body: Container(
          height: 500,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: parkingLocations.length,
              itemBuilder: (context, index) {
                return LocationsCard(parkingLocation: parkingLocations[index]);
              }),
        ),
    );
  }
}