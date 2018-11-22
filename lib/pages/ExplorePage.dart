import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



class ExplorePage extends StatefulWidget {

    @override
    State<StatefulWidget> createState() {
        return _ExploreState();
    }

}


class _ExploreState extends State<ExplorePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text("Thank you for letting us know you are intersted in this feature."),
            ),
        );
    }
}
