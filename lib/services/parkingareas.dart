import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parkingareas.dart';

class Parkingservices {
  Future<bool> postParkingservices({
    String address = "",
    String country = "",
    String state = "",
    int max2vehicles = 0,
    int max4vehicles = 0,
    int mobileNumber = 0,
    int pincode = 0,
  }) async {
    Map<String, dynamic> data = {
      'max2vehicles': max2vehicles,
      'max4vehicles': max4vehicles,
      'mobileNumber': mobileNumber,
      'address': address,
      'pincode': pincode,
      'state': state,
      'country': country,
    };

    await FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection('parkingareas')
        .add(data)
        .then((value) {
      print(value);
    });
    return true;
  }

  Future<List<Parkingareas>> fetchParkingservices() async {
    List<Parkingareas> list = [];

    await FirebaseFirestore.instance
        .collection('giveplaceusers')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection('parkingareas')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(Parkingareas.fromMap(element.data()));
      });
    });
    return list;
  }
}
