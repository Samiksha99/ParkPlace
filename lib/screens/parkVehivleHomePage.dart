import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late Position _currentPosition;

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
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

  @override
  void initState() {
    _getCurrentLocation();

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
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: Center(
          child: Text(
            'Find Parking areas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
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
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
            Container(
              height: 500,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: parkingLocations.length,
                  itemBuilder: (context, index) {
                    return LocationsCard(
                        parkingLocation: parkingLocations[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
