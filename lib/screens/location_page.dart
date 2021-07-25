import 'dart:ui';
import 'package:park_place/screens/slots.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:park_place/Location/google_maps.dart';
import 'package:park_place/models/locations.dart';
import 'package:park_place/screens/mainPage.dart';
import 'package:park_place/screens/slots.dart';

final themeMode = ValueNotifier(2);

// class CarouselDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       builder: (context, value, g) {
//         return MaterialApp(
//           initialRoute: '/',
//           themeMode: ThemeMode.values.toList()[value as int],
//           debugShowCheckedModeBanner: false,
//           routes: {
//             '/': (ctx) => PrefetchImageDemo(),
//           },
//         );
//       },
//       valueListenable: themeMode,
//     );
//   }
// }

class PrefetchImageDemo extends StatefulWidget {
  final Locations currLocation;

  const PrefetchImageDemo({Key? key, required this.currLocation})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PrefetchImageDemoState();
  }
}

class _PrefetchImageDemoState extends State<PrefetchImageDemo> {
  final List<String> imagesList = [
    'https://houseintegrals.com/wp-content/uploads/modern-house-interior.jpg',
    'https://static.livebooks.com/e80db8405fef420eb008b4f05ccf479a/i/ec4d5808531446d3b31b918503cfef01/1/4SoifmQp45JMgBnHp7ed2/Modern%20Lake%20House%20-%20Galina%20Coada%20Photography%201.jpg',
    'https://i.pinimg.com/originals/b5/dd/ac/b5ddac4119e838f2b4d37eea565fc779.jpg',
    'https://www.achahomes.com/wp-content/uploads/2017/12/The-Blue-House-Design-with-3-Bedrooms-like-1.jpg',
    'https://assets.weforum.org/article/image/okmt2ZLizHlhoN0C_IFzjk0PxZ_xNJWRvknyKqCK-Uw.jpg',
    'https://pix10.agoda.net/hotelImages/9065853/-1/142d78192fda46d5b58e14c9d3f2fe51.jpg?s=1024x768',
    'https://i.pinimg.com/originals/66/d9/f5/66d9f5afdc5337d3f9eac362b970c426.jpg',
  ];

  int _currentIndex = 0;

  String? _StartTime;
  String? _EndTime;

  //payment method starts
  final razorpay = Razorpay();
  TextEditingController controller = TextEditingController();

  void initState() {
    super.initState();
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paySuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, payError);
  }

  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void paySuccess(PaymentSuccessResponse response) {
    print(response.paymentId.toString());
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void payError(PaymentFailureResponse response) {
    print(response.message);
  }

  getPayment(String amount) {
    var option = {
      'key': 'rzp_test_x8HVnQqW8V4ugg',
      'amount': num.parse(amount) * 100,
      'name': 'REciever Name',
      'prefill': {
        'contact': '9456092025',
        'email': 'maheshwaridhruv25@gmail.com'
      },
      "external": {
        "wallets": ["paytm"]
      },
      "description": "This is a Test Payment",
      // "timeout": "180",
      // "theme.color": "#03be03",
      // "currency": "INR",
    };

    try {
      razorpay.open(option);
    } catch (e) {
      print(e.toString());
    }
  }

  //payment method ends
  Future<void> _show1() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      print(result.format(context));
      setState(() {
        _StartTime = result.format(context);
      });
    }
  }

  Future<void> _show2() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      print(result.format(context));
      setState(() {
        _EndTime = result.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[800],
          title: Center(
            child: Text('Park Place'),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MainPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
                items: imagesList
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: EdgeInsets.only(
                            top: 10.0,
                            bottom: 0.0,
                          ),
                          elevation: 6.0,
                          shadowColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagesList.map((urlOfItem) {
                  int index = imagesList.indexOf(urlOfItem);
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.8)
                          : Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  );
                }).toList(),
              ),
              Container(
                // height: double.infinity,
                color: Colors.blueGrey[50],
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Center(
                          child: Text(
                            widget.currLocation.address,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 25, 0.0, 0.0),
                            child: Column(
                              children: [
                                Text(
                                  'Owner\'s Name:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  widget.currLocation.ownerNmae,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\u{20B9}${50}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rent per Hour',
                                  style: TextStyle(
                                    color: Colors.purple,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                            Container(
                              child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MapView(
                                          widget.currLocation.address)));
                                },
                                color: Colors.green,
                                icon: Icon(
                                  Icons.directions,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Directions',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              widget.currLocation.address,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              Text('Mobile Number: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '+91 ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    widget.currLocation.mobileNumber.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: RaisedButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          onPressed: () {
                            getPayment("150");
                          },
                          child: Text(
                            'Pay And Park',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: RaisedButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => Slots(),
                              ),
                            );
                          },
                          child: Text(
                            'Slots',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
