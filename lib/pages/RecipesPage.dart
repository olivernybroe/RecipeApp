import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:MealEngineer/pages/AddRecipe.dart';



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
            body: _buildBody(context),

            floatingActionButton: new FloatingActionButton(
                onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRecipe()),
                        );
                    },
                tooltip: 'Create a recipe',
                child: new Icon(Icons.add),
            ),
        );
    }


    Widget _buildBody(BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').document('WnUSOQjMQbfxS0dsCobG').collection('recipes').snapshots(),
            builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildList(context, snapshot.data.documents);
            },
        );
    }

    Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
        return ListView(
            padding: const EdgeInsets.only(top: 20.0),
            children: snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
    }

    Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
        final recipe = Recipe.fromSnapshot(data);

        return Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.album),
                        title: Text(recipe.name),
                        subtitle: Text(
                            'A really nice subtitle'),
                    ),
                ],
            ),
        );
    }

}
