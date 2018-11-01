import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



class PlanPage extends StatefulWidget {

    @override
    State<StatefulWidget> createState() {
        return _PlanState();
    }

}


class _PlanState extends State<PlanPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                color: Colors.blue,
            ),
        );
    }
}
