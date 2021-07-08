import "package:flutter/material.dart";
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
  var debugText = 'Waiting for button press';

  _LoginPageState(DatabaseComm dbc) {
    this.dbComm = dbc;
    this.dbComm.connectToCollections();
  }

  void submitLoginDetails() async {
    var res =
        await dbComm.login(usernameController.text, passwordController.text);
    setState(() {
      this.debugText = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login'),
          TextField(
            obscureText: false,
            controller: this.usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'username',
            ),
          ),
          TextField(
            obscureText: false,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
            ),
          ),
          Text(this.debugText),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: submitLoginDetails,
        child: Text('Login'),
      ),
    );
  }
}
