import 'package:flutter/material.dart';
import 'package:recept_skafferiet/recipe.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final session;

  RecipeCard(this.session, this.recipe);

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
                    null,
                    "",
                    this.recipe.ingredients,
                    this.recipe.instructions,
                    this.recipe.extra,
                    this.recipe.portions)
                  );
          },
          child: SizedBox(
              width: 300,
              height: 200,
              child: Column(
                children: [
                  ImageBanner(this.recipe.image, 100), // TODO: Make more stylish
                  Text(this.recipe.title), // TODO: Make more stylish
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: this.recipe.ingredients.length,
                      itemBuilder: (context, index){
                      return Text(this.recipe.ingredients[index], 
                      style: TextStyle(color: Colors.grey),);
                      })
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
