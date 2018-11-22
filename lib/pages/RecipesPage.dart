import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/main.dart';



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
                onPressed: null,
                tooltip: 'Create a recipe',
                child: new Icon(Icons.add),
            ),
        );
    }


    Widget _buildBody(BuildContext context) {
        return StreamBuilder(
            stream: auth.currentUser().asStream(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();

                return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').document(snapshot.data.uid).collection('recipes').snapshots(),
                    builder: (context, snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();

                        return _buildList(context, snapshot.data.documents);
                    },
                );
            }
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

        return RecipeCard(recipe);
    }

}
