import 'package:flutter/material.dart';

class Account extends StatefulWidget{
  var session;
  Account(this.session);
  @override
  State<StatefulWidget> createState() => _AccountState(this.session);

}

class _AccountState extends State<Account>{
  var session;
  logout(){
    
  }
  _AccountState(this.session);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Mitt konto, your session: ' + this.session),
          TextButton(onPressed: logout, child: Text('Logga ut')),
          ]
        )
    );
  }
  
}