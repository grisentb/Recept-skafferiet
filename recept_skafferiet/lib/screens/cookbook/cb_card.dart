import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

import '../../recipe.dart';

class CBCard extends StatelessWidget {
  final Recipe recipe;
  final relation;
  final session;

  CBCard(this.session, this.recipe, this.relation);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, RecipeScreen.route,
                arguments: RecipeScreenArguments(
                    this.session,
                    this.recipe.title,
                    this.recipe.url,
                    this.recipe.image,
                    this.relation['rating'],
                    this.relation['comment'],
                    this.recipe.ingredients,
                    this.recipe.instructions,
                    this.recipe.extra,
                    this.recipe.portions));
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
                          this.recipe.image,
                          fit: BoxFit.cover,
                        )),
                  ] // TODO: Make more stylish
                      ),
                  Column(children: [
                    Text(this.recipe.title, style: TextStyle(fontWeight: FontWeight.bold)), // TODO: Make more stylish
                    RatingBarIndicator(
                      rating: this.relation['rating'],
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    Text(((){
                      if(this.relation['comment'] != null){
                        return this.relation['comment'];
                      }else {
                        return "";
                      }
                    }())),
                  ])
                ],
              )),
        ),
      ),
    );
  }
}
