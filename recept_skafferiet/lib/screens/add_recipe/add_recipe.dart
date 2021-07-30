import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/add_recipe/recipe_form.dart';

class NewRecipe extends StatelessWidget {
  var session;
  NewRecipe(this.session);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NewRecipeStateful(this.session));
  }
}

class NewRecipeStateful extends StatefulWidget {
  final session;
  NewRecipeStateful(this.session);

  @override
  _NewRecipeStatefulState createState() =>
      _NewRecipeStatefulState(this.session);
}

class _NewRecipeStatefulState extends State<NewRecipeStateful> {
  var session;
  _NewRecipeStatefulState(this.session);

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
