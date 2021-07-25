import 'package:flutter/material.dart';
// import 'package:tezster_dart/tezster_dart.dart';

class TezosPayPage extends StatefulWidget {
  const TezosPayPage({ Key? key }) : super(key: key);

  @override
  _TezosPayPageState createState() => _TezosPayPageState();
}

class _TezosPayPageState extends State<TezosPayPage> {

  // String balance='0';
  // void getBalance() async{
  //   balance = await TezsterDart.getBalance(senderAddress, 'http://localhost:18732'); 
  // }
  // @override
  // void initState(){
  //   getBalance();
  // }
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String senderAddress='';
  String recipientAddress='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        automaticallyImplyLeading: false,
        title: Center(child: Text('Tezos Wallet', style: TextStyle(color: Colors.black),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      onPressed: () {
                        // getBalance();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.purple[200],
                    ),
                  ),
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Senders Account Address", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple.withOpacity(.08),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Senders Account Address',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.35),
                          ),
                        ),
                        validator: (val) {
                          setState(() {
                            senderAddress = val!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Recipient Account Address", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple.withOpacity(.08),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Recipient Account Address',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.35),
                          ),
                        ),
                        validator: (val) {
                          setState(() {
                            recipientAddress = val!;
                          });
                        },
                      ),
                    ),
                  ],     
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Balance: ", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    Text(
                      "balance", 
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => TezosPayPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.purple[200],
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