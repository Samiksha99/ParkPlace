import 'package:flutter/material.dart';
import 'package:park_place/screens/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_place/screens/parkVehivleHomePage.dart';
import 'package:park_place/screens/profilePageUser.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  int currenttab = 0;
  final List<Widget> screen = [
    ParkVehicleHome(),
    History(),
    ProfilePageUser(FirebaseAuth.instance.currentUser!.phoneNumber),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = ParkVehicleHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[900],
        child: Icon(Icons.home,),
        onPressed: () {
          setState(() {
            currenttab = 0;
            currentScreen = ParkVehicleHome();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = ProfilePageUser(
                        FirebaseAuth.instance.currentUser!.phoneNumber);
                    currenttab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: currenttab == 01 ? Colors.deepPurple[200] : Colors.grey,
                    ),
                    Text('Profile',
                        style: TextStyle(
                          color:
                              currenttab == 1 ? Colors.deepPurple[300] : Colors.grey[600],
                        ))
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = History();
                    currenttab = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color: currenttab == 2 ? Colors.deepPurple[200] : Colors.grey[600],
                    ),
                    Text('History',
                        style: TextStyle(
                          color: currenttab == 2 ? Colors.deepPurple[300] : Colors.grey,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
