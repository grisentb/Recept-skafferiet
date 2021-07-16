import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/home/recipe_card.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class Home extends StatelessWidget {
  final session;
  Home({this.session});

  @override
  Widget build(BuildContext context) {
    final title = 'Alla recept, session: ' + this.session['sessionToken'];
    return MaterialApp(
      title: title,
      onGenerateRoute: (settings) {
        if (settings.name == RecipeScreen.route) {
          final args = settings.arguments as RecipeScreenArguments;

          return MaterialPageRoute(builder: (context) {
            return RecipeScreen(
                name: args.name,
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
          children: List.generate(10, (index) {
            return Center(
                child: RecipeCard(
                    "https://assets.icanet.se/e_sharpen:80,q_auto,dpr_1.25,w_718,h_718,c_lfill/imagevaultfiles/id_229834/cf_259/pappardelle_med_portabello_och_sparris.jpg",
                    "smaskig pasta",
                    4.3));
          }),
        ),
      ),
    );
  }
}
