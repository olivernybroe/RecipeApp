import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



class ShoppingListPage extends StatefulWidget {

    @override
    State<StatefulWidget> createState() {
        return _ShoppingListState();
    }

}


class _ShoppingListState extends State<ShoppingListPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                color: Colors.grey,
            ),
        );
    }
}
