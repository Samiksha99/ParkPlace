import 'package:park_place/screens/bookings.dart';

import '../models/parkingareas.dart';
import 'package:flutter/material.dart';

class ParkingCard extends StatefulWidget {
  final Parkingareas parkingareas;
  const ParkingCard({Key? key, required this.parkingareas}) : super(key: key);

  @override
  _ParkingCardState createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Bookings(parkingArea: widget.parkingareas)),
        );
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Text(widget.parkingareas.address),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("2 wheelers : ${widget.parkingareas.max2vehicles}"),
                      Text("4 wheelers: ${widget.parkingareas.max4vehicles}"),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
