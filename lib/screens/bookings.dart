import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_place/models/parkingareas.dart';
import 'package:intl/intl.dart';

class Bookings extends StatefulWidget {

  final Parkingareas parkingArea;
  const Bookings({Key? key, required this.parkingArea}) : super(key: key);


  @override
  _BookingsState createState() => _BookingsState();
}

String id='';

class _BookingsState extends State<Bookings> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('giveplaceusers');

  set max2vehicles(max2vehicles) {}
  set startTime(startTime) {}
  set endTime(endTime) {}

  String address = "";
  String state = "";
  String country = "";
  int? mobilenumber;
  int? pincode;
  int? twowheels;
  int? fourwheels;
  bool selected = false;
  List selectedslots = [];

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
  List<bool> arr = new List<bool>.generate(24, (index) => false);

  @override
  void initState() {
    getslots();
    getparkingAreaId();
    super.initState();
  }

  void savechanges() async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection('parkingareas')
        .doc(id)
        .update({'timeSlots': arr});

        showDialog( 
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Updated"),
            content: Text("You have updated TimeSlots"),
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
  String todatDate= DateFormat('yyyy-MM-dd').format(DateTime.now());
  void getparkingAreaId() async{
    await users
      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
      .collection('parkingareas')
      .get().then((value){
        value.docs.forEach((element) {
          if(element['address'] == widget.parkingArea.address){
            id = element.id;
            print("First-id $id");
          }
        });
      });
  }
  
  Future<void> getslots() async {
    print("first $arr");
    print("id $id");
    await users
      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
      .collection('parkingareas')
      .doc(id)
      .get()
      .then((value) {
        setState(() {
          arr = List.from(value['timeSlots']);
        });
        twowheels = value['max2vehicles'];
        fourwheels = value['max4vehicles'];
        mobilenumber = value['mobileNumber'];
        address = value['address'];
        pincode = value['pincode'];
        state = value['state'];
        country = value['country'];
      });
    print("last $arr");
  }

  void updateplace() async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection('parkingareas')
        .doc(id)
        .update({
      'max2vehicles': twowheels,
      'max4vehicles': fourwheels,
      'mobileNumber': mobilenumber,
      'address': address,
      'pincode': pincode,
      'state': state,
      'country': country
    });
    showDialog( 
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Updated"),
        content: Text("You have updated TimeSlots"),
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

  void slotsselection(val) {
    setState(() {
      selected = !selected;
      if (selected == true) {
        selectedslots.add(val);
        arr[val] = true;
      }
      if (selected == false && selectedslots.contains(val)) {
        selectedslots.remove(val);
        arr[val] = false;
      }
    });
  }

  colorselect(val) {
    if (arr[val] == true) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Bookings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
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
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                child: (TextFormField(
                                  onChanged: (text) {
                                    address = text;
                                  },
                                  initialValue: address,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter an address';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue: pincode.toString(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a valid pincode';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue: state,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a state';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue: twowheels.toString(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a number';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue: fourwheels.toString(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a number';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue:country,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a country name';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  initialValue: mobilenumber.toString(),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a valid mobile number';
                                    }
                                    return null;
                                  },
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
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
                                  if (value == null || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ))
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 40.0),
                                child: ElevatedButton(
                                  child: Text('Submit'),
                                  onPressed: () {
                                    updateplace();
                                  },
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
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: Center(child: Text(todatDate, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: allSlots.length,
                itemBuilder: (BuildContext context, int index) {
                  return InputChip(
                    onPressed: () {
                      slotsselection(index);
                    },
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      allSlots[index],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: colorselect(index) == true
                        ? Colors.blue[800]
                        : Colors.blue[50],
                    elevation: 6.0,
                    shadowColor: Colors.grey[60],
                    padding: EdgeInsets.all(8.0),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  savechanges();
                },
                child: Text("Save Changes")),
          )
        ]));
  }
}
