import "package:flutter/material.dart";
import "../Database Communication/databaseComm.dart";

class RegisterPage extends StatefulWidget{
  final dbComm = new DatabaseComm();
  @override
  State<StatefulWidget> createState() => _RegisterPageState(dbComm);
  
}

class _RegisterPageState extends State<RegisterPage> {
  DatabaseComm dbComm;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var debugText = 'Waiting for button press';

  _RegisterPageState(DatabaseComm dbc){
    this.dbComm = dbc;
    this.dbComm.connectToCollections();
  }

  void submitDetails() async{
    dbComm.register(usernameController.text, passwordController.text);
    setState(() {
      this.debugText = "Registered!";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register'),
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
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitDetails,
        child: Text('Register'),
      ),
    );
  }
  
}