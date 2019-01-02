import 'package:MealEngineer/Models/Recipe.dart';
import 'package:flutter/material.dart';

class RecipeCard extends Card {
  final Recipe recipe;
  final GestureTapCallback onTap;
  final BuildContext context;

  RecipeCard(this.context, this.recipe, {this.onTap});

  @override
  Widget get child => GestureDetector(
    onTap: this.onTap ?? () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => _infoScreen(context)
          )
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: recipe.image != null
              ? CircleAvatar(backgroundImage: recipe.image)
              : Icon(Icons.album),
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
    ),
  );

  Widget _infoScreen(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            this.recipe.name,
        ),
        actions: <Widget>[
        ],
      ),
      body: _fields(context),
    );
  }

  Widget _fields(BuildContext context)
  {
    return ListView(
      children: ListTile.divideTiles(
          context: context,
          tiles: [
            _getBackground(),
            _timeAndServings(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(recipe.description ?? ''),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.ingredients.map((String ingredient) => Text(ingredient)).toList(),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Instructions",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    recipe.instructions,
                  ),
                ),
              ],
            )
          ]
      ).toList(),
    );
  }

  Row _timeAndServings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              size: 36,
            ),
            Text(
              ' ' + (((recipe.prepTime ?? 0)+(recipe.cookTime ?? 0))/60).floor().toString() + ' m',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        VerticalDivider(),
        Row(
          children: <Widget>[
            Icon(
              Icons.person,
              size: 36,
            ),
            Text(
              ' ' + (recipe.servings ?? '?').toString() + " servings",
              style: TextStyle(fontSize: 18),
            )
          ],
        )
      ],
    );
  }


  Container _getBackground () {
    return Container(
      child: Image(
        image: recipe.image,
        fit: BoxFit.cover,
        height: 250.0,
      ),
      constraints: BoxConstraints.expand(height: 250.0),
    );
  }
}

