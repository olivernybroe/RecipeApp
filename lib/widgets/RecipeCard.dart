import 'package:MealEngineer/Models/Recipe.dart';
import 'package:flutter/material.dart';

class RecipeCard extends Card {
  final Recipe recipe;

  RecipeCard(this.recipe);

  @override
  Widget get child => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ListTile(
        leading: recipe.image,
        title: Text(recipe.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.person),
                Text(' ' + (recipe.servings ?? '?').toString() + " servings")
              ],
            ),
            Text('   '),
            Row(
              children: <Widget>[
                Icon(Icons.access_time),
                Text(' ' + (((recipe.prepTime ?? 0)+(recipe.cookTime ?? 0))/60).floor().toString() + ' m')
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

