import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/add_recipe/recipe_form.dart';

class NewRecipe extends StatelessWidget {
  var session;
  NewRecipe(this.session);
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lägg till nytt recept';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: RecipeForm(),
      ),
    );
  }
}
