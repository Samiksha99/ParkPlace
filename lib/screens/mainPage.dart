import 'package:flutter/material.dart';
import 'package:park_place/screens/loginScreen.dart';
import 'package:park_place/utilities/dimensions.dart';

var vpH, vpW, owner = false;

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "ParkPlace",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(isowner: true)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.blue[900],
                  ),
                  icon: Icon(
                    Icons.directions,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Rent your Place',
                      style:
                          TextStyle(color: Colors.white, fontSize: vpH * 0.03),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(isowner: false)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.pink,
                  ),
                  icon: Icon(
                    Icons.directions,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Park your Vehicle',
                      style:
                          TextStyle(color: Colors.white, fontSize: vpH * 0.03),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
