import 'package:flutter/material.dart';
import 'package:park_place/screens/history.dart';
import 'package:park_place/screens/profile.dart';
import 'package:park_place/screens/dashboard.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenttab = 0;
  final List<Widget> screen = [
    Dashbord(),
    History(),
    Profile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashbord();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: (){
          setState(() {
            currenttab=0;
            currentScreen=Dashbord();
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
                onPressed: (){
                  setState(() {
                  currentScreen = Profile();
                  currenttab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(
                    Icons.account_circle,
                    color:currenttab==01? Colors.blue:Colors.grey,
                    
                  ),
                  Text(
                    'Profile',
                    style:TextStyle(
                      color: currenttab == 1? Colors.blue : Colors.grey[600],
                    )
                  )
                ],
                ),
                ),
                MaterialButton(
                minWidth: 40,
                onPressed: (){
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
                    color:currenttab==2 ? Colors.blue:Colors.grey[600],
                    
                  ),
                  Text(
                    'History',
                    style:TextStyle(
                      color: currenttab == 2? Colors.blue : Colors.grey,
                    )
                  )
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