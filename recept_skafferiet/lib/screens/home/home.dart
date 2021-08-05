import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/home/recipe_card.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';
import 'dart:convert';

import '../../recipe.dart';

class Home extends StatelessWidget {
  var session;
  Home(sess) {
    this.session = json.decode(sess);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeStateful(this.session));
  }
}

class HomeStateful extends StatefulWidget {
  final session;
  HomeStateful(this.session);
  @override
  _HomeStatefulState createState() => _HomeStatefulState(this.session);
}

class _HomeStatefulState extends State<HomeStateful> {
  var session;
  List<Widget> recipes = [];
  _HomeStatefulState(sess){
    this.session = sess;
    update();
  }


  void update() async {
    List<Widget> newRecipelist = [];
    var res = await ApiCommunication.getRecipes(this.session['user_id'], this.session['sessionToken']);
    res = json.decode(res);
    for (var recipe in res){
      List<String> ing = [...recipe['ingridients']];
      List<String> ins = [...recipe['instructions']];
      Recipe tempRecipe = new Recipe(
        recipe['title'], 
        ing, 
        ins, 
        recipe['extra'], 
        recipe['url'], 
        recipe['portions'], 
        recipe['image']
      );
      newRecipelist.add(
      Center(child: RecipeCard(
          this.session,
          tempRecipe
          ),)
      );
    }
    setState(() {
      this.recipes = newRecipelist;
    });

  }

  @override
  Widget build(BuildContext context) {
    final title = 'Alla recept i Recept Skafferiet';
    return MaterialApp(
      title: title,
      onGenerateRoute: (settings) {
        if (settings.name == RecipeScreen.route) {
          final args = settings.arguments as RecipeScreenArguments;

          return MaterialPageRoute(builder: (context) {
            return RecipeScreen(
                name: args.name,
                session: args.session,
                comment: args.comment,
                url: args.url,
                imgPath: args.imgPath,
                score: args.score,
                ingredients: args
                    .ingredients, //Later these should be loaded in when rendered
                instructions: args
                    .instructions, //Later these should be loaded in when rendered
                extra: args.extra,
                portions: args.portions);
          });
        } else {
          return null;
        }
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: this.recipes
          
        ),
      ),
    );
  }
}
