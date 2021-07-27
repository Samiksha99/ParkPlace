import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_place/models/locations.dart';

class Locationservices {
  Future<bool> postlocationservices({
    String address = "",
    int max2vehicles = 0,
    int max4vehicles = 0,
    int mobileNumber = 0,
    String ownerNmae = "",
    List<dynamic>? timeSlots ,
    String? id ="",
    String? ownerid = "",

  }) async {
    Map<String, dynamic> data = {
      'max2vehicles': max2vehicles,
      'max4vehicles': max4vehicles,
      'mobileNumber': mobileNumber,
      'address': address,
      'ownerNmae': ownerNmae,
      'timeSlots':timeSlots,
      'id':id,
      'ownerid':ownerid
    };

    await FirebaseFirestore.instance
        .collection('parkingPlaces')
        .add(data)
        .then((value) {
      print(value);
    });
    return true;
  }

  Future<List<Locations>> fetchLocationservices() async {
    List<Locations> list = [];

    await FirebaseFirestore.instance
        .collection('parkingPlaces')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        list.add(Locations.fromMap(element.data()));
      });
    });
    return list;
  }
}