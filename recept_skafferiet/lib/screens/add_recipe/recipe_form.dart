import 'package:flutter/material.dart';
import 'package:recept_skafferiet/WebScraping/controller.dart';
import 'dart:convert';

// Create a Form widget.
class RecipeForm extends StatefulWidget {
  final session;
  RecipeForm(this.session);
  @override
  RecipeFormState createState() {
    return RecipeFormState(this.session);
  }
}

class RecipeFormState extends State<RecipeForm> {
  var session;
  RecipeFormState(sess) {
    this.session = json.decode(sess);
  }
  final _formKey = GlobalKey<FormState>();
  String errMsg = '';
  bool inputSuccess = false;
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    // A form to paste url of recipe to save in the database
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              // Text field of form
              child: TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                    hintText: "Klistra in URL...",
                    border: OutlineInputBorder()),
              )),
          Container(
              width: 250,
              height: 60,
              child:
                  // Error message text
                  Text(
                errMsg,
                style:
                    TextStyle(color: inputSuccess ? Colors.green : Colors.red),
                textAlign: TextAlign.left,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: ElevatedButton(
              onPressed: () async {
                // Loading animation
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Läser URL...')));

                //On button press try the url if it is compatible and
                //added to database relation gives input success
                var message = '';
                if (urlController.text.isEmpty) {
                  message = "Var god och skriv in något";
                } else {
                  message = await submitUrl(this.session['user_id'],
                      this.session['sessionToken'], urlController.text);
                }
                setState(() {
                  errMsg = message;
                  if (message == "Receptet är nu tillagt i din kokbok!") {
                    inputSuccess = true;
                  } else {
                    inputSuccess = false;
                  }
                });
              },
              child: Text('Ladda ned'),
            ),
          ),
        ],
      ),
    );
  }
}

submitUrl(uid, session, url) async {
  return await addScrapeNew(uid, session, url);
}
