import 'package:flutter/material.dart';


class RecipesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
      return _RecipeState();
  }

}


class _RecipeState extends State<RecipesPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Card(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        const ListTile(
                            leading: Icon(Icons.album),
                            title: Text('The Enchanted Nightingale'),
                            subtitle: Text(
                                'Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                    ],
                ),
            ),

            floatingActionButton: new FloatingActionButton(
                onPressed: null,
                tooltip: 'Create a recipe',
                child: new Icon(Icons.add),
            ),
        );
    }

}