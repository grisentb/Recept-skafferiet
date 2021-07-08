import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  final List<String> _ingredients;

  IngredientsList(this._ingredients);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(), // MAKES NOT SCROLLABLE
          padding: const EdgeInsets.all(8),
          itemCount: _ingredients.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Text(
                  (index + 1).toString() + "  " + '${_ingredients[index]}'),
            );
          }),
    );
  }
}
