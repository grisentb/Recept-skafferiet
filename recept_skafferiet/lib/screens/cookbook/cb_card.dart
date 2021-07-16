import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class CBCard extends StatelessWidget {
  final String _imgPath;
  final String _name;
  final double _score;

  CBCard(this._imgPath, this._name, this._score);

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
              child: Row(
                children: [
                  Column(children: [
                    Container(
                        constraints: BoxConstraints.expand(
                            //needs both height and width otherwise results in error
                            height: 100,
                            width: 100),
                        decoration: BoxDecoration(color: Colors.grey),
                        child: Image.network(
                          _imgPath,
                          fit: BoxFit.cover,
                        )),
                  ] // TODO: Make more stylish
                      ),
                  Column(children: [
                    Text(_name), // TODO: Make more stylish
                    RatingBar.builder(
                      initialRating: _score,
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
                    )
                  ])
                ],
              )),
        ),
      ),
    );
  }
}
