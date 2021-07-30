import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/ingredients_list.dart';
import 'package:recept_skafferiet/screens/recipe/instructions_list.dart';

class RecipeScreen extends StatelessWidget {
  final session;
  static const route = '/recipeScreen';
  final String name;
  final String imgPath;
  final double score;
  final List<String> ingredients;
  final List<String> instructions;
  final String extra;
  final int portions;

  const RecipeScreen(
      {Key key,
      @required this.name,
      @required this.imgPath,
      @required this.score,
      @required this.ingredients,
      @required this.instructions,
      @required this.extra,
      @required this.portions,
      @required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RecipeScreenStateful(this.session, name, imgPath, score,
            ingredients, instructions, extra, portions));
  }
}

class RecipeScreenStateful extends StatefulWidget {
  final session;
  static const route = '/recipeScreen';
  final String name;
  final String imgPath;
  final double score;
  final List<String> ingredients;
  final List<String> instructions;
  final String extra;
  final int portions;
  RecipeScreenStateful(this.session, this.name, this.imgPath, this.score,
      this.ingredients, this.instructions, this.extra, this.portions);
  @override
  _RecipeScreenStatefulState createState() => _RecipeScreenStatefulState(
      session,
      name,
      imgPath,
      score,
      ingredients,
      instructions,
      extra,
      portions);
}

class _RecipeScreenStatefulState extends State<RecipeScreenStateful> {
  var session;
  String name;
  String imgPath;
  double score;
  List<String> ingredients;
  List<String> instructions;
  String extra;
  int portions;

  _RecipeScreenStatefulState(session, name, imgPath, score, ingredients,
      instructions, extra, portions) {
    this.session = session;
    this.name = name;
    this.imgPath = imgPath;
    this.score = score;
    this.ingredients = ingredients;
    this.instructions = instructions;
    this.extra = extra;
    this.portions = portions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
      ),
      body: ListView(
        children: [
          ImageBanner(imgPath, 200.0),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              )),
          Align(
            alignment: Alignment.center,
            child: RatingBar.builder(
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
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: IntrinsicHeight(
                  child: Row(children: [
                Expanded(
                  child: Text(
                    extra,
                    textAlign: TextAlign.right,
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  thickness: 2,
                  width: 20,
                ),
                Expanded(
                  child: Text(portions.toString() + " portioner"),
                ),
              ]))),
          Divider(color: Colors.black, thickness: 2),
          SizedBox(
              width: double.infinity,
              child: Container(
                child: Text("Ingredients:",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )),
          IngredientsList(ingredients),
          Divider(color: Colors.black, thickness: 2),
          SizedBox(
              width: double.infinity,
              child: Container(
                child: Text("Instructions:",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )),
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
  final String extra;
  final int portions;

  RecipeScreenArguments(this.name, this.imgPath, this.score, this.ingredients,
      this.instructions, this.extra, this.portions);
}
