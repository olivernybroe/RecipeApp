import 'package:MealEngineer/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



class ShoppingListPage extends Page {
  @override
  BottomNavigationBarItem navigationBarItem(BuildContext context) {
      return BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Shopping List')
      );
  }

  @override
  Widget pageView(BuildContext context) {
      return _ShoppingListPage();
  }

}

class _ShoppingListPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _ShoppingListState();
    }
}


class _ShoppingListState extends State<_ShoppingListPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text("Thank you for letting us know you are intersted in the shopping card feature."),
            ),
        );
    }
}
