import "package:flutter/material.dart";
import 'package:recept_skafferiet/main_navigation.dart';
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
    //this.dbComm.connectToCollections();
  }

  submitLoginDetails() async {
    //var session = await dbComm.login(usernameController.text, passwordController.text);
    var session = {"username": "thomas", "password": "asouidh1o2834y9823yt"};
    if (session != null) {
      //Navigera till Nav() med session som context
      Navigator.pushNamed(context, Nav.route, arguments: NavArguments(session));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: missing_return
      onGenerateRoute: (settings) {
        if (settings.name == Nav.route) {
          final args = settings.arguments as NavArguments;
          return MaterialPageRoute(builder: (context) {
            return Nav(session: args.session);
          });
        }
      },
      home: Scaffold(
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
      ),
    );
  }
}
