class Parkingareas {
 String address = "";
    String country = "";
    String state = "";
    int max2vehicles = 0;
    int max4vehicles = 0;
    int mobileNumber = 0;
    int pincode = 0;
    

  Parkingareas({
    required this.address,
    required this.country,
    required this.state,
    required this.max2vehicles,
    required this.max4vehicles,
    required this.mobileNumber,
    required this.pincode,
  });

  Map toMap(Parkingareas parkingareas) {
    var data = Map<String, dynamic>();
    data['address'] = parkingareas.address;
    data['country'] = parkingareas.country;
    data['state'] = parkingareas.state;
    data['max2vehicles'] = parkingareas.max2vehicles;
    data['max4vehicles'] = parkingareas.max4vehicles;
    data['mobileNumber'] = parkingareas.mobileNumber;
    data['pincode'] = parkingareas.pincode;
    return data;
  }

  // Named constructor
  Parkingareas.fromMap(Map<String, dynamic> mapData) {
    this.address = mapData['address'];
    this.country = mapData['country'];
    this.state = mapData['state'];
    this.max2vehicles = mapData['max2vehicles'];
    this.max4vehicles = mapData['max4vehicles'];
    this.mobileNumber = mapData['mobileNumber'];
    this.pincode = mapData['pincode'];
  }
}