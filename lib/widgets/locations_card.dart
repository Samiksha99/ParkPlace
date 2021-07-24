import 'package:flutter/material.dart';
import 'package:park_place/models/locations.dart';
import 'package:park_place/screens/location_page.dart';

class LocationsCard extends StatefulWidget {

  final Locations parkingLocation;
  const LocationsCard({ Key? key, required this.parkingLocation }) : super(key: key);

  @override
  _LocationsCardState createState() => _LocationsCardState();
}

class _LocationsCardState extends State<LocationsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrefetchImageDemo(currLocation: widget.parkingLocation))
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 5),
                  spreadRadius: 2.0,
                ),
              ],
            ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(widget.parkingLocation.address),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.parkingLocation.ownerNmae,
                      ),
                      Text(
                        "2 wheelers : ${widget.parkingLocation.max2vehicles}"
                      ),
                      Text(
                        "4 wheelers: ${widget.parkingLocation.max4vehicles}"
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}