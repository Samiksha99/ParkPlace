import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(.2),
        body: Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }
}
