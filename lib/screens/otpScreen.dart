import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:park_place/screens/Home.dart';
import 'package:park_place/screens/detailsScreen.dart';
import 'package:park_place/screens/loginScreen.dart';
import 'package:park_place/screens/parkVehivleHomePage.dart';
import 'package:park_place/screens/parkvehicleDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool owner = false;

class OTPScreen extends StatefulWidget {
  final phone = LoginScreen.phone;

  OTPScreen({Key? key}) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Invalid OTP! Try again'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
  );

  late String _verificationCode, userCode;
  bool codeSent = false, verifying = false;

  void showSnackBar(String msg, Color color) {
    var snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> checkRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    owner = (pref.getBool('ownerRole') ?? false);
  }

  _phoneVerified() async {
    if (owner) {
      await FirebaseFirestore.instance
          .collection("giveplaceusers")
          .doc('+91' + widget.phone!)
          .get()
          .then(
        (value) {
          if (value.exists) {
            // Navigator.pushReplacementNamed(context,'/ownerHomePage');
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else {
            FirebaseFirestore.instance
                .collection("giveplaceusers")
                .doc(
                  '+91' + LoginScreen.phone!,
                )
                .set(
              {
                'fullName': 'Name',
                'mobileNumber': '+91' + LoginScreen.phone!,
              },
            );
            // Navigator.pushReplacementNamed(context, '/detailsScreen');
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new DetailsScreen(),
              ),
            );
          }
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection("parkvehicleusers")
          .doc('+91' + widget.phone!)
          .get()
          .then(
        (value) {
          if (value.exists) {
            // Navigator.pushReplacementNamed(context,'/location_page');
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ParkVehicleHome(),
              ),
            );
          } else {
            FirebaseFirestore.instance
                .collection("parkvehicleusers")
                .doc(
                  '+91' + LoginScreen.phone!,
                )
                .set(
              {
                'fullName': 'Name',
                'mobileNumber': '+91' + LoginScreen.phone!,
              },
            );
            // Navigator.pushReplacementNamed(context, '/parkvehicleDetailPage');
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ParkDetailsScreen(),
              ),
            );
          }
        },
      );
    }
  }

  _verifyPhone(phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            log('# Created #');
            _phoneVerified();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        log(e.message!);
        showSnackBar('Something went wrong !', Colors.red);
        Navigator.pushReplacementNamed(context, '/loginScreen');
      },
      codeSent: (String? verficationID, int? resendToken) {
        setState(() {
          _verificationCode = verficationID!;
          codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        showSnackBar('OTP verification timed out !', Colors.red);
        Navigator.pushReplacementNamed(context, '/loginScreen');
      },
      timeout: Duration(seconds: 60),
    );
  }

  _verifyOTP() async {
    _formkey.currentState!.validate();
    if (userCode.isNotEmpty && userCode.length == 6) {
      try {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
                verificationId: _verificationCode, smsCode: userCode))
            .then((value) async {
          if (value.user != null) {
            _phoneVerified();
          }
        });
      } catch (e) {
        log(e.toString());
        FocusScope.of(context).unfocus();
        showSnackBar('Invalid OTP! Try again', Colors.red);
        setState(() {
          verifying = false;
        });
      }
    } else {
      showSnackBar('Invalid OTP! Try again', Colors.red);
      setState(() {
        verifying = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkRole();
    _verifyPhone(widget.phone);
    log(widget.phone!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showSnackBar('You cannot go back at this stage ', Colors.grey[600]!);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: owner? Colors.blue[200] : Colors.purple[300],
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: !codeSent
                ? Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white60,
                      size: 30,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OTP sent.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                "Enter the OTP sent to  +91 ${widget.phone}  to continue...",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _formModule(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _formModule() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
      child: Form(
        key: _formkey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.white.withOpacity(.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "ParkPlace.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(.05),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
                          child: TextFormField(
                            maxLength: 6,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: 'Enter OTP',
                              hintStyle: TextStyle(
                                color: Colors.white60.withOpacity(.35),
                              ),
                            ),
                            obscureText: false,
                            validator: (val) {
                              setState(() {
                                userCode = val!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //shadowColor: Colors.white38,
                  primary: Colors.white,

                  elevation: 10,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (!verifying) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      verifying = true;
                    });
                    _verifyOTP();
                  }
                },
                child: Container(
                  width: 120,
                  height: 18,
                  child: Center(
                    child: verifying
                        ? SpinKitFadingCircle(
                            color: Colors.black54,
                            size: 20,
                          )
                        : Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
