import 'package:MealEngineer/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';


class ExplorePage extends Page {
  @override
  BottomNavigationBarItem navigationBarItem(BuildContext context) {
      return BottomNavigationBarItem(
          icon: Icon(Icons.public),
          title: Text("Explore"),
      );
  }

  @override
  Widget pageView(BuildContext context) {
      return _ExplorePage();
  }

  @override
  AppBar appBar(BuildContext context) {
      return AppBar(
          title: Text("Explore"),
      );
  }
}


class _ExplorePage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _ExploreState();
    }
}


class _ExploreState extends State<_ExplorePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text("Thank you for letting us know you are intersted in this feature."),
            ),
        );
    }
}
