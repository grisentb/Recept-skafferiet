import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class CategoryCard extends StatelessWidget {
  final String _name;

  CategoryCard(this._name);

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
                  4.3,
                  ["pasta", "salt", "kärlek"],
                  [
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
                  ],
                  "Tar 20 min liksom",
                  4));
        },
        child: SizedBox(
          width: 400,
          height: 100,
          child: Row(children: [
            Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.02, 0, 0, 0)),
            Text(this._name)
          ]),
        ),
      ),
    ));
  }
}
