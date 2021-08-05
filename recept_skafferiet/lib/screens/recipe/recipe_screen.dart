import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/cookbook/cookbook.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/ingredients_list.dart';
import 'package:recept_skafferiet/screens/recipe/instructions_list.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen_no_relation.dart';
import 'dart:convert';


class RecipeScreen extends StatelessWidget {
  final session;
  static const route = '/recipeScreen';
  final String name;
  final String url;
  final String imgPath;
  final double score;
  final String comment;
  final List<String> ingredients;
  final List<String> instructions;
  final String extra;
  final int portions;

  const RecipeScreen(
      {Key key,
      @required this.name,
      @required this.url,
      @required this.imgPath,
      @required this.score,
      @required this.comment,
      @required this.ingredients,
      @required this.instructions,
      @required this.extra,
      @required this.portions,
      @required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RecipeScreenStateful(this.session, name, url, imgPath, score, comment,
            ingredients, instructions, extra, portions));
  }
}

class RecipeScreenStateful extends StatefulWidget {
  final session;
  static const route = '/recipeScreen';
  final String name;
  final String url;
  final String imgPath;
  final double score;
  final String comment;
  final List<String> ingredients;
  final List<String> instructions;
  final String extra;
  final int portions;
  RecipeScreenStateful(this.session, this.name, this.url, this.imgPath, this.score, this.comment,
      this.ingredients, this.instructions, this.extra, this.portions);
  @override
  _RecipeScreenStatefulState createState() => _RecipeScreenStatefulState(
      session,
      name,
      url,
      imgPath,
      score,
      comment,
      ingredients,
      instructions,
      extra,
      portions);
}

class _RecipeScreenStatefulState extends State<RecipeScreenStateful> {
  var session;
  String name;
  String url;
  String imgPath;
  double score;
  String comment;
  List<String> ingredients;
  List<String> instructions;
  String extra;
  int portions;

  final commentController = TextEditingController();

  _RecipeScreenStatefulState(session, name, url, imgPath, score, comment, ingredients,
      instructions, extra, portions) {
    this.session = session;
    this.name = name;
    this.url = url;
    this.imgPath = imgPath;
    this.score = score;
    this.comment = comment;
    this.ingredients = ingredients;
    this.instructions = instructions;
    this.extra = extra;
    this.portions = portions;
  }
  void deleteFromMyRecipes() async {
    await ApiCommunication.deleteRelation(this.session['user_id'], this.session['sessionToken'], this.url);
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CookBook(json.encode(this.session))));
  }
  void updateComment() async {
    var textEntry = this.commentController.text;
    var res = await ApiCommunication.updateComment(this.session['user_id'], this.session['sessionToken'], this.url, textEntry);
    setState(() {
      this.comment = textEntry;
      this.commentController.text = "";
    });
  }

  void updateScore(rating) async {
    var res = await ApiCommunication.updateRating(
      this.session['user_id'], 
      this.session['sessionToken'], 
      this.url, 
      rating);
    setState(() {
      this.score = rating as double;
    });
  }

  void returnToCookbook() async {
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CookBook(json.encode(this.session))));
  }
  @override
  Widget build(BuildContext context) {
    if(this.score != null){
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back
          ),
          onTap: returnToCookbook,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
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
                  updateScore(rating);
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
          Container(
            child: Row(
              children: [
              Text((() {
                if(this.comment != null){
                  return "Kommentar: ";
                }
                return "";
              })(), style: TextStyle(fontWeight: FontWeight.bold),), 
              Text(this.comment),
            ],
            )
          ),
          TextField(
            obscureText: false,
            controller: this.commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lägg till Kommentar',
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(),
            onPressed: updateComment, 
            child: Text("Kommentera", style: TextStyle(fontWeight: FontWeight.bold,))
          ),
          Padding(padding: EdgeInsets.all(50)),
          ElevatedButton(
            onPressed: deleteFromMyRecipes, 
            child: Text("Ta bort från min kokbok"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
        ],
      ),
    );
    }else {
      return recipeScreenNoRelation(context, this.session, this.name, this.url, this.imgPath, this.ingredients, this.instructions, this.extra, this.portions);
    }
  }
}

class RecipeScreenArguments {
  final session;
  final String name;
  final String url;
  final String imgPath;
  final double score;
  final String comment;
  final List<String> ingredients;
  final List<String> instructions;
  final String extra;
  final int portions;

  RecipeScreenArguments(this.session, this.name, this.url, this.imgPath, this.score,this.comment, this.ingredients,
      this.instructions, this.extra, this.portions);
}
