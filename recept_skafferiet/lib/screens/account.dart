import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/Login.dart';
import 'dart:convert';

class Account extends StatefulWidget{
  var session;
  Account(this.session);
  @override
  State<StatefulWidget> createState() => _AccountState(this.session);

}

class _AccountState extends State<Account>{
  var session;
  void logout() async {
    await ApiCommunication.logout(this.session['user_id'], this.session['sessionToken']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  _AccountState(sess){
    this.session = json.decode(sess);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Mitt konto, your session: ' + this.session.toString()),
          TextButton(onPressed: logout, child: Text('Logga ut')),
          ]
        )
    );
  }
  
}