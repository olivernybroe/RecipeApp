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
        leading: Icon(Icons.album),
        title: Text(recipe.name),
        subtitle: Text('A really nice subtitle'),
      ),
    ],
  );
}

