import "package:flutter/material.dart";
import 'package:recept_skafferiet/screens/Login.dart';
import "../DatabaseCommunication/databaseComm.dart";

class RegisterPage extends StatefulWidget {
  final dbComm = new DatabaseComm();
  @override
  State<StatefulWidget> createState() => _RegisterPageState(dbComm);
}

class _RegisterPageState extends State<RegisterPage> {
  DatabaseComm dbComm;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  _RegisterPageState(DatabaseComm dbc) {
    this.dbComm = dbc;
  }

  void submitRegisterDetails() async {
    await this.dbComm.connectToCollections();
    await this
        .dbComm
        .register(usernameController.text, passwordController.text);
    await this.dbComm.closeDB();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
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
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lösenord',
                ),
              ),
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
