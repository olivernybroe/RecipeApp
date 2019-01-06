import 'package:MealEngineer/Models/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeCard extends Card {
  final Recipe recipe;
  final GestureTapCallback onTap;
  final BuildContext context;
  final FirebaseUser currentUser;

  RecipeCard(this.context, this.recipe, {this.onTap, this.currentUser});

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
    return _RecipeInfoScreen(context, recipe, currentUser);
  }
}

class _RecipeInfoScreen extends Scaffold {
  final Recipe recipe;
  final BuildContext context;
  final FirebaseUser currentUser;

  _RecipeInfoScreen(this.context, this.recipe, this.currentUser);


  @override
  PreferredSizeWidget get appBar => AppBar(
    title: Text(
      this.recipe.name,
    ),
    actions: <Widget>[
      Builder(builder: (context) => IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Thank you for letting us know that you are instersted in a edit feature.'),
          );

          Scaffold.of(context).showSnackBar(snackBar);
        }
      )),
    ],
  );

  @override
  Widget get body => _fields(context);

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
            _ingredients(context),
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
                    recipe.instructions ?? '',
                  ),
                ),
              ],
            )
          ]
      ).toList(),
    );
  }

  Column _ingredients(BuildContext context) {
    List<Widget> ingredients;
    if(recipe.ingredients != null) {
      ingredients = recipe.ingredients.map((String ingredient) => Text(ingredient)).toList();
    } else {
      ingredients = [
        Text("No ingredients...")
      ];
    }

    return Column(
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
            children: ingredients,
          ),
        )
      ],
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
    Widget image;
    if(recipe.image != null) {
      image = Image(
        image: recipe.image,
        fit: BoxFit.cover,
        height: 250.0,
      );
    }
    else {
      image = Container(
        color: Colors.redAccent,
        child: null,
      );
    }

    return Container(
      child: image,
      constraints: BoxConstraints.expand(height: 250.0),
    );
  }
}