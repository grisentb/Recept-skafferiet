import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/cookbook/cb_card.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class CookBook extends StatelessWidget {
  var session;
  CookBook(this.session);
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
        }
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          crossAxisCount: 1,
          children: List.generate(10, (index) {
            return Center(
                child: CBCard(
                    "https://assets.icanet.se/e_sharpen:80,q_auto,dpr_1.25,w_718,h_718,c_lfill/imagevaultfiles/id_229834/cf_259/pappardelle_med_portabello_och_sparris.jpg",
                    "smaskig pasta",
                    4.3));
          }),
        ),
      ),
    );
  }
}
