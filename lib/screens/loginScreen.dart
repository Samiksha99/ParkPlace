import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:park_place/screens/otpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool role=false;
class LoginScreen extends StatefulWidget {
  static String? phone;
  final bool isowner;

  LoginScreen({ Key? key, required this.isowner}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Please enter valid phone number'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
  );

  @override
  void initState(){
    fetchRole();
    super.initState();
  }

  void fetchRole() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(widget.isowner){
      await pref.setBool('ownerRole', true);
    }
    else{
      await pref.setBool('ownerRole', false);
    }
  }

  void _signIn() async {
    _formkey.currentState!.validate();
    if (LoginScreen.phone!.isNotEmpty && LoginScreen.phone!.length == 10) {
      // Navigator.pushReplacementNamed(context, "/otpScreen");
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => OTPScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.withOpacity(.2),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: widget.isowner? Colors.blue[200]: Colors.purple[300],
          body: SingleChildScrollView(
          child:Column(
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
                      "Welcome.",
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
                        "Enter your phone number to continue...",
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
              Padding(
                padding: EdgeInsets.only(top:50.0),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    child: widget.isowner? Image.asset("assets/images/login2.png") : Image.asset("assets/images/login1.png") ,
                  ),
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
                          "ParkPlace",
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
                            maxLength: 10,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              prefixText: "+91 ",
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                color: Colors.white60.withOpacity(.35),
                              ),
                            ),
                            obscureText: false,
                            validator: (val) {
                              log(val!);
                              setState(() {
                                LoginScreen.phone = val;
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        //Spacer(),
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
                  FocusScope.of(context).unfocus();
                  _signIn();
                },
                child: Container(
                  width: 120,
                  child: Center(
                    child: Text(
                      "Send OTP",
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
