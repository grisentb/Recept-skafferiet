import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/ingredients_list.dart';
import 'package:recept_skafferiet/screens/recipe/instructions_list.dart';

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
          RatingBar.builder(
            initialRating: score,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
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
