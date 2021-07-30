import "package:flutter/material.dart";
import 'package:recept_skafferiet/main_navigation.dart';
import 'package:recept_skafferiet/screens/Register.dart';
import "../DatabaseCommunication/databaseComm.dart";

class LoginPage extends StatefulWidget {
  final dbComm = new DatabaseComm();
  @override
  State<StatefulWidget> createState() => _LoginPageState(dbComm);
}

class _LoginPageState extends State<LoginPage> {
  DatabaseComm dbComm;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var wrongDetails = '';

  _LoginPageState(DatabaseComm dbc) {
    this.dbComm = dbc;
    //this.dbComm.connectToCollections();
  }

  void submitLoginDetails() async {
    // await this.dbComm.connectToCollections();
    // setState(() {
    //   this.wrongDetails = 'Connected (I think)';
    // });
    // var session = await this
    //     .dbComm
    //     .login(this.usernameController, this.passwordController);
    var session = {"username": "Hector", "sessionToken": "hihihi"};
    print(session);
    if (session != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Nav(session)));
    } else {
      setState(() {
        this.wrongDetails = "Felaktigt användarnamn eller lösenord";
      });
    }
  }

  void navigateToRegister() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
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
            Text('Logga in'),
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
            Text(
              this.wrongDetails,
              style: TextStyle(color: Colors.red),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: submitLoginDetails, child: Text('Logga in')),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02)),
                ElevatedButton(
                    onPressed: navigateToRegister, child: Text('Registrera'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
