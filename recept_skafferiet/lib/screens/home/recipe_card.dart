import 'package:flutter/material.dart';
import 'package:recept_skafferiet_app/screens/image_banner.dart';
import 'package:recept_skafferiet_app/screens/recipe/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  final String _imgPath;
  final String _name;
  final double _score;

  RecipeCard(this._imgPath, this._name, this._score);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, RecipeScreen.route,
                arguments: RecipeScreenArguments(
                    "Smaskig Pasta",
                    "https://assets.icanet.se/e_sharpen:80,q_auto,dpr_1.25,w_718,h_718,c_lfill/imagevaultfiles/id_229834/cf_259/pappardelle_med_portabello_och_sparris.jpg",
                    4.3, [
                  "pasta",
                  "salt",
                  "kärlek"
                ], [
                  "koka pasta",
                  "salta",
                  "slafsa i dig pasta",
                  "dansa macarena",
                  "offra din förstfödde till flying spaghetti monster",
                  "dasasdasddasdas",
                  "dasasdasddasdas",
                  "dasasdasddasdas",
                  "dasasdasddasdas",
                  "dasasdasddasdas",
                  "dasasdasddasdas",
                ]));
          },
          child: SizedBox(
              width: 200,
              height: 300,
              child: Column(
                children: [
                  ImageBanner(_imgPath, 150.0), // TODO: Make more stylish
                  Text(_name), // TODO: Make more stylish
                  Text(_score.toString() +
                      " av 5") // TODO: Make more stylish and add flutter_rating_bar
                ],
              )),
        ),
      ),
    );
  }
}
