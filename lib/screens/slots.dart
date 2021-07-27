import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:park_place/models/locations.dart';

import 'mainPage.dart';

String todatDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

List<int> availableSlotsList = [];

class Slots extends StatefulWidget {
  final Locations currentLocation;
  const Slots({Key? key, required this.currentLocation}) : super(key: key);

  @override
  _SlotsState createState() => _SlotsState();
}

List<String> arr = new List<String>.generate(24, (index) => "false");
int len = 0;
bool selected = false;
List selectedslots = [];
CollectionReference users = FirebaseFirestore.instance
    .collection('giveplaceusers')
    .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
    .collection('parkingareas');

List allSlots = [
  '12AM-1AM',
  '1AM-2AM',
  '2AM-3AM',
  '3AM-4AM',
  '4AM-5AM',
  '5AM-6AM',
  '6AM-7AM',
  '7AM-8AM',
  '8AM-9AM',
  '9AM-10AM',
  '10AM-11AM',
  '11AM-12PM',
  '12PM-1PM',
  '1PM-2PM',
  '2PM-3PM',
  '3PM-4PM',
  '4PM-5PM',
  '5PM-6PM',
  '6PM-7PM',
  '7PM-8PM',
  '8PM-9PM',
  '9PM-10PM',
  '10PM-11PM',
  '11PM-12PM'
];

class _SlotsState extends State<Slots> {
  String ownername = '';
  String vehicleNumber = '';
  String bookingid = "";
  void getslots() async {
    availableSlotsList = [];
    print(widget.currentLocation.id);
    await FirebaseFirestore.instance
        .collection('parkingPlaces')
        .doc(widget.currentLocation.id)
        .get()
        .then((value) async {
      arr = List.from(value['timeSlots']);
      for (var i = 0; i < arr.length; i++) {
        if (arr[i] == "true") {
          setState(() {
            availableSlotsList.add(i);
          });
          // print("fdfs");
        }
      }
      // selectedslotstrue = [];
      await FirebaseFirestore.instance
          .collection('giveplaceusers')
          .doc(widget.currentLocation.ownerid)
          .collection('bookings')
          .doc(bookingid)
          .get()
          .then((value) {
        if (value['isdispatech'] == false) {
          selectedslotstrue = value['timing'];
          vehicleNumber = value['vehicleNumber'];
        } else {
          selectedslotstrue = [];
        }
        print(vehicleNumber);
      });
    });
  }

  Future<void> getOwnerName() {
    return FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .then((value) {
      ownername = value['fullName'];
    });
  }

  // Future<void> getinfoselectedslots() async {
  //   selectedslotstrue = [];
  //   return FirebaseFirestore.instance
  //       .collection('giveplaceusers')
  //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  //       .collection('bookings')
  //       .doc('kmQxTo74JbFM8838f8GH')
  //       .get()
  //       .then((value) {
  //     if (value['isdispatch'] == false) {
  //       selectedslotstrue = List.from(value['timing']);
  //     }
  //   });
  // }

  // len = availableSlotsList.length;
  // print("available $availableSlotsList");
  // // print(availableSlotsList.length);
  // print("array $arr");
  // }

  List selectedslotstrue = [];
  void slotsselection(val) {
    // print('slots1 $arr');
    setState(() {
      selected = !selected;
      if (selected == true && !selectedslotstrue.contains((val))) {
        // selectedslots.add(val);
        selectedslotstrue.add(val);
        selected = false;
        // arr[val] = "true";
      } else if (selectedslotstrue.contains(val)) {
        selectedslotstrue.remove(val);
        selected = false;
        // arr[val] = "false";
      }
    });
    // print('slots2 $selectedslots');
    print('sl $selectedslotstrue');
  }

  void savechanges() async {
    for (var i = 0; i < selectedslotstrue.length; i++) {
      // ignore: unnecessary_statements
      int ind = availableSlotsList[selectedslotstrue[i]];
      // arr[availableSlotsList[selectedslotstrue[i]] = "selected" as int;
      arr[ind] = "selected";
    }
    await FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(widget.currentLocation.ownerid)
        .update({'timeSlots': arr});
    await FirebaseFirestore.instance
        .collection('parkingPlaces')
        .doc(widget.currentLocation.id)
        .update({'timeSlots': arr});
    await FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(widget.currentLocation.ownerid)
        .collection('bookings')
        .add({
      'owner': ownername,
      'vehicleowner': ownername,
      'isparked': true,
      'isdispatech': false,
      'ismoneytransfered': true,
      'vehicleNumber': vehicleNumber,
      'timing': selectedslotstrue,
      'placeid': widget.currentLocation.id
    }).then((value) => bookingid = value.id);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Updated"),
        content: Text("You have selected TimeSlots"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pop(context);
            },
            child: Text("okay"),
          ),
        ],
      ),
    );
  }

  void dispatchvehicle() async {
    for (var i = 0; i < selectedslotstrue.length; i++) {
      // ignore: unnecessary_statements
      int ind = availableSlotsList[selectedslotstrue[i]];
      // arr[availableSlotsList[selectedslotstrue[i]] = "selected" as int;
      arr[ind] = "true";
    }
    print("gjhgjghgjhgjhghj $arr");
    await users.doc('ARCPkVlWr5FtyfLhgKvJ').update({'timeSlots': arr});
    await FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection('bookings')
        .doc('kmQxTo74JbFM8838f8GH')
        .update({
      'isdispatech': true,
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Updated"),
        content:
            Text("Yor are picking your vehicle.Hope You like our service."),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pop(context);
            },
            child: Text("okay"),
          ),
        ],
      ),
    );
  }

  colorselect(val) {
    // print("vjjgj $val");
    if (selectedslotstrue.contains(val)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    getslots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Center(
                child: Text(
                  'Slots',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              automaticallyImplyLeading: true,
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
            body: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Center(
                    child: Text(
                  todatDate,
                  style: TextStyle(fontSize: 25),
                )),
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: availableSlotsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InputChip(
                        onPressed: () {
                          slotsselection(index);
                        },
                        labelPadding: EdgeInsets.all(2.0),
                        label: Text(
                          allSlots[availableSlotsList[index]],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        // ignore: unrelated_type_equality_checks
                        backgroundColor: colorselect(index) == true
                            ? Colors.green
                            : Colors.blue[50],
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: EdgeInsets.all(8.0),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: TextFormField(
                  initialValue: vehicleNumber,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: vehicleNumber == ""
                          ? "Vehicle Number"
                          : vehicleNumber),
                  onChanged: (text) {
                    vehicleNumber = text;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter an valid number';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    savechanges();
                  },
                  child: Text("Parked")),
              ElevatedButton(
                  onPressed: () {
                    dispatchvehicle();
                  },
                  child: Text("Dispatch")),
            ])));
  }
}