class Locations {
 String address = "";
    String ownerNmae = "";
    int max2vehicles = 0;
    int max4vehicles = 0;
    int mobileNumber = 0;
    List<dynamic>? timeSlots;
    String? id ="";
    String? ownerid = "";

  Locations({
    required this.address,
    required this.ownerNmae,
    required this.max2vehicles,
    required this.max4vehicles,
    required this.mobileNumber,
    required this.timeSlots,
    required this.id,
    required this.ownerid,
  });

  Map toMap(Locations locations) {
    var data = Map<String, dynamic>();
    data['address'] = locations.address;
    data['ownerNmae'] = locations.ownerNmae;
    data['max2vehicles'] = locations.max2vehicles;
    data['max4vehicles'] = locations.max4vehicles;
    data['mobileNumber'] = locations.mobileNumber;
    data['timeSlots'] = locations.timeSlots;
    data['id'] = locations.id;
    data['ownerid'] = locations.ownerid;
    return data;
  }

  // Named constructor
  Locations.fromMap(Map<String, dynamic> mapData) {
    this.address = mapData['address'];
    this.ownerNmae = mapData['ownerNmae'];
    this.max2vehicles = mapData['max2vehicles'];
    this.max4vehicles = mapData['max4vehicles'];
    this.mobileNumber = mapData['mobileNumber'];
    this.timeSlots = mapData['timeSlots'];
    this.id = mapData['id'];
    this.ownerid = mapData['ownerid'];
  }
}