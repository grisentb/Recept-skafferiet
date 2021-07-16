import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  final List<String> _ingredients;

  IngredientsList(this._ingredients);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // MAKES NOT SCROLLABLE
          padding: const EdgeInsets.all(8),
          itemCount: _ingredients.length,
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 30,
              child: Text(
                  (index + 1).toString() + "  " + '${_ingredients[index]}'),
            );
          }),
    );
  }
}
