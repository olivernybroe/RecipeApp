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
  final bool isPublic;

  RecipeCard(this.context, this.recipe, {this.onTap, this.currentUser, this.isPublic : false});

  RecipeCard.public(this.context, this.recipe, this.currentUser, {this.onTap, this.isPublic : true});

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
    List<Widget> actions;
    if(isPublic == true) {
      actions = [
        Builder(builder: (context) => IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              recipe.addToCookBook(currentUser);
              final snackBar = SnackBar(
                content: Text('Added recipe to your cookbook'),
              );

              Scaffold.of(context).showSnackBar(snackBar);
            }
        ))
      ];
    }


    return _RecipeInfoScreen(
      context,
      recipe,
      currentUser,
      actions: actions,
    );
  }
}

class _RecipeInfoScreen extends Scaffold {
  final Recipe recipe;
  final BuildContext context;
  final FirebaseUser currentUser;
  final List<Widget> actions;

  _RecipeInfoScreen(this.context, this.recipe, this.currentUser, {this.actions});

  @override
  PreferredSizeWidget get appBar => AppBar(
    title: Text(
      this.recipe.name,
    ),
    actions: actions ?? <Widget>[
      _edit(),
      _publishDialog(),
    ],
  );

  Builder _edit() {
    return Builder(builder: (context) => IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        final snackBar = SnackBar(
          content: Text('Thank you for letting us know that you are instersted in a edit feature.'),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      }
    ));
  }

  Builder _publishDialog() {
    return Builder(builder: (context) => IconButton(
      icon: Icon(Icons.public),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                this.recipe.public == null ? "Publish recipe?" : "Update published recipe",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              content: Text("This will publish ${recipe.name} so other users can see the recipe. If it's already published it will update it."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.recipe.publish(currentUser);
                  },
                  child: Text(this.recipe.public == null ? "Publish" : 'Update'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                  textColor: Theme.of(context).disabledColor,
                ),
              ],
            );
          }
        );
      },
    ));
  }

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
      return null;
    }

    return Container(
      child: image,
      constraints: BoxConstraints.expand(height: 250.0),
    );
  }
}