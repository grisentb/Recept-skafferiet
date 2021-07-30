import 'package:flutter/material.dart';

// Create a Form widget.
class RecipeForm extends StatefulWidget {
  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Klistra in URL...",
                    border: OutlineInputBorder()),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Var snäll och skriv in någon text';
                  }
                  return null;
                },
              )),
          /* 
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
           */
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Läser URL...')));
                }
              },
              child: Text('Ladda ned'),
            ),
          ),
        ],
      ),
    );
  }
}
