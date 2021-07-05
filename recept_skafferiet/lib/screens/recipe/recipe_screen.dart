import 'package:flutter/material.dart';
import 'package:recept_skafferiet_app/screens/image_banner.dart';
import 'package:recept_skafferiet_app/screens/recipe/ingredients_list.dart';
import 'package:recept_skafferiet_app/screens/recipe/instructions_list.dart';

class RecipeScreen extends StatelessWidget {
  static const route = '/recipeScreen';
  final String name;
  final String imgPath;
  final double score;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeScreen({
    Key key,
    @required this.name,
    @required this.imgPath,
    @required this.score,
    @required this.ingredients,
    @required this.instructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          ImageBanner(imgPath, 200.0),
          Text(name),
          Text(score.toString() + " av 5"),
          IngredientsList(ingredients),
          InstructionsList(instructions),
        ],
      ),
    );
  }
}

class RecipeScreenArguments {
  final String name;
  final String imgPath;
  final double score;
  final List<String> ingredients;
  final List<String> instructions;

  RecipeScreenArguments(
      this.name, this.imgPath, this.score, this.ingredients, this.instructions);
}
