import "package:flutter/material.dart";
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/Login.dart';
import "../DatabaseCommunication/databaseComm.dart";

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var userNotification = '';

  void submitRegisterDetails() async {
    var res = await ApiCommunication.register(this.usernameController.text, this.passwordController.text);
    if(res == "true"){
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }else {
      setState(() {
        this.userNotification = 'User already exists';
      });
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Receptskafferiet')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Registrera'),
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  obscureText: false,
                  controller: this.usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Användarnamn',
                  ),
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                obscureText: false,
                controller: this.passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lösenord',
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              child: Text(this.userNotification, style: TextStyle(color: Colors.red),),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: submitRegisterDetails,
                    child: Text('Registrera')),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02)),
                ElevatedButton(
                    onPressed: navigateToLogin, child: Text('Tillbaka'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
