import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// This class gives the opportunity to choose a recipe.
/// It will return the selected recipe.
class ChooseRecipe extends Scaffold{
    final MealType mealType;
    final BuildContext context;
    final FirebaseUser currentUser;

    ChooseRecipe(this.context, this.currentUser, this.mealType);

    @override
    PreferredSizeWidget get appBar => AppBar(
        title: Text(
            "Add a recipe to your ${mealType.name.toLowerCase()}"
        ),
    );

    @override
    Widget get body => Builder(builder: (BuildContext context) =>
            _buildBody(context)
        );

    Widget _buildBody(BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users')
                .document(currentUser.uid).collection('recipes').snapshots(),
            builder: (context, snapshot) {
                if (!snapshot.hasData) {
                    return Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: 80.0,
                            width: 80.0,
                            child: CircularProgressIndicator(strokeWidth: 6.0,),
                        )
                    );
                }

                return _buildList(context, snapshot.data.documents);
            },
        );
    }

    Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
        return ListView(
            children: snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
    }

    Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
        final recipe = Recipe.fromSnapshot(data);
        return RecipeCard(
            context,
            recipe,
            currentUser: currentUser,
            onTap: () {
                Navigator.pop(context, recipe);
            },
        );
    }
}