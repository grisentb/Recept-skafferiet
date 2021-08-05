import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/cookbook/cb_card.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';
import 'dart:convert';

import '../../recipe.dart';

class CookBook extends StatelessWidget {
  var session;
  CookBook(sess) {
    this.session = json.decode(sess);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CookBookStateful(this.session));
  }
}

class CookBookStateful extends StatefulWidget {
  final session;
  CookBookStateful(this.session);
  @override
  _CookBookStatefulState createState() => _CookBookStatefulState(this.session);
}

class _CookBookStatefulState extends State<CookBookStateful> {
  final controller = ScrollController();
  var session;
  List<Widget> recipes = [];

  _CookBookStatefulState(sess){
    this.session = sess;
    update();
  }


  void update() async {
    List<Widget> newRecipelist = [];
    var res = await ApiCommunication.getMyRecipes(this.session['user_id'], this.session['sessionToken']);
    res = json.decode(res);

    var i = 0;
    while(i < res['recipes'].length) {
      var recipe = json.decode(res['recipes'][i]);
      var relation = json.decode(res['relations'][i]);
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
      Center(child: CBCard(
          this.session,
          tempRecipe,
          relation
          ),)
      );
      i += 1;
    }
    setState(() {
      this.recipes = newRecipelist;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Min kokbok';
    return MaterialApp(
      title: title,
      onGenerateRoute: (settings) {
        if (settings.name == RecipeScreen.route) {
          final args = settings.arguments as RecipeScreenArguments;

          return MaterialPageRoute(builder: (context) {
            return RecipeScreen(
                session: args.session,
                name: args.name,
                url: args.url,
                imgPath: args.imgPath,
                score: args.score,
                comment: args.comment,
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
        body: ListView.builder(
          controller: controller,
            shrinkWrap: true,
            itemCount: this.recipes.length,
            itemBuilder: (context, index) {
              return Center(
                  child: this.recipes[index]
                  );
            }),
      ),
    );
  }
}
