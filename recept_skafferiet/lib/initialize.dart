import "package:flutter/material.dart";
import 'package:recept_skafferiet/main_navigation.dart';
import 'package:recept_skafferiet/screens/Register.dart';
import 'package:recept_skafferiet/screens/Login.dart';
import "../DatabaseCommunication/apiComm.dart";
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class Init extends StatefulWidget {
  @override
  _InitState createState() => _InitState();
}

class _InitState extends State<Init> {
  Future<void> signInNaviagtion() async {
    // Fetches the current session stored locally
    await GetStorage.init();
    await Future.delayed(Duration(seconds: 3));
    final localStorage = GetStorage();
    var localSession = localStorage.read('session');

    // If no session is stored then naviagte to login
    if (localSession == "Route not found" || localSession == null) {
      localStorage.remove('session');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // Decodes the stored session and checks if it is valid
      var decodedSession = json.decode(localSession);
      var localUserId = decodedSession['user_id'];
      var localSessionToken = decodedSession['sessionToken'];
      var isSignedIn =
          await ApiCommunication.validSession(localUserId, localSessionToken);

      // If session is valid then push this session to home page
      if (json.decode(isSignedIn)) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Nav(localSession)));
      } else {
        // If not valid remove session and move to login
        localStorage.remove('session');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder<void>(
          future: signInNaviagtion(),
          builder: (ctx, snapshot) {
            return _buildLoader();
          }),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: Container(
          width: 100, height: 100, child: CircularProgressIndicator()),
    );
  }
}
