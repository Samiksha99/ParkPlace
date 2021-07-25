import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_place/models/locations.dart';
import 'package:park_place/screens/mainPage.dart';
import 'package:park_place/services/locations.dart';
import 'package:park_place/widgets/locations_card.dart';

class ParkVehicleHome extends StatefulWidget {
  const ParkVehicleHome({Key? key}) : super(key: key);

  @override
  _ParkVehicleHomeState createState() => _ParkVehicleHomeState();
}

class _ParkVehicleHomeState extends State<ParkVehicleHome> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;
  List<Locations> parkingLocations = [];
  List<dynamic> parkLocations = [];
  late double lat;
  late double long;
  static LatLng _initialPosition = LatLng(0, 0);
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        Position _currentPosition = position;
        lat = _currentPosition.latitude;
        long = _currentPosition.longitude;
        print('CURRENT POS: $_currentPosition');
        _initialPosition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        print(_initialPosition);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> getLocations()async{
    setState(() async{
      final List<DocumentSnapshot> documents = await GeoFirestore(FirebaseFirestore.instance
      .collection('parkingPlaces'))
      .getAtLocation(GeoPoint(lat, long), 0.001);
      documents.forEach((document) {
        setState(() {
          parkLocations.add(document);
        });
        print(document.data);
      });
    });
  }
  @override
  void initState() {
    _getCurrentLocation();
    // getLocations();
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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: Text(
          'Welcome Page',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
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
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // or use fixed size like 200
              height: 200.0,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(target: _initialPosition),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Container(
                height: 475,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: parkingLocations.length,
                    itemBuilder: (context, index) {
                      return LocationsCard(
                          parkingLocation: parkingLocations[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}