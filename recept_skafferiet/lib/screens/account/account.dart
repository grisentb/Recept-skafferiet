import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/Login.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class Account extends StatefulWidget {
  var session;
  Account(this.session);
  @override
  State<StatefulWidget> createState() => _AccountState(this.session);
}

class _AccountState extends State<Account> {
  var session;
  void logout() async {
    await ApiCommunication.logout(
        this.session['user_id'], this.session['sessionToken']);

    //removes session from local storage
    await GetStorage.init();
    final localStorage = GetStorage();
    localStorage.remove('session');

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    //remove from local storage
  }

  _AccountState(sess) {
    this.session = json.decode(sess);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Text('Mitt konto'),
      TextButton(onPressed: logout, child: Text('Logga ut')),
    ]));
  }
}
