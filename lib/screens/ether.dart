import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Ether extends StatefulWidget {
  const Ether({Key? key}) : super(key: key);

  @override
  _EtherState createState() => _EtherState();
}

class _EtherState extends State<Ether> {
  String rpcurl = "http://192.168.43.33:7545";
  String wsUrl = "ws://192.168.43.33:7545/";
  Future<void> sendether() async {
    Web3Client client = Web3Client(rpcurl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    String privateKey =
        "d5fb299cb13b45bc8c812d215514b11ef68c2e522cc2aeb26beff545f6bc8405";
    Credentials credentials =
        await client.credentialsFromPrivateKey(privateKey);
    EthereumAddress recieverAddress =
        EthereumAddress.fromHex("0xFf66E43Bb010959d1C4D155b2dA5aaF4fe23ddA7");
    EthereumAddress ownAddress = await credentials.extractAddress();
    print(recieverAddress);
    client
        .sendTransaction(
            credentials,
            Transaction(
                from: ownAddress,
                to: recieverAddress,
                value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 20)))
        .then((value) => print('done'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Ether',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                onPressed: () {
                  sendether();
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
