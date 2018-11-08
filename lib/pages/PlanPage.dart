import 'package:MealEngineer/Models/Plan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:intl/intl.dart';



class PlanPage extends StatefulWidget {

    @override
    State<StatefulWidget> createState() {
        return _PlanState();
    }

}

const List<String> tabNames = const<String>[
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
];


class _PlanState extends State<PlanPage> with AutomaticKeepAliveClientMixin<PlanPage> {

    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: DefaultTabController(
                length: Plan.now().days.length,
                initialIndex: 1,
                child: Scaffold(
                    appBar: AppBar(
                        bottom: _buildTabBar(context)
                    ),
                    body: TabBarView(
                        children: Plan.now().days.map((day) {
                            return ListView.builder(
                                itemCount: MealType.values.length,
                                itemBuilder: (BuildContext context, int index){
                                    var mealType = MealType.values[index];
                                    return Column(
                                        children: <Widget>[
                                            Text(
                                                mealType.toString().substring(mealType.toString().indexOf('.')+1),
                                                style: TextStyle(
                                                    //decoration: TextDecoration.underline,
                                                    fontSize: 30.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                            ),
                                            Column(
                                                children: day.meals.where((meal) => meal.mealType == mealType).map((meal) {
                                                    return Card(
                                                        child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                                ListTile(
                                                                    leading: Icon(Icons.album),
                                                                    title: Text(meal.recipe.name),
                                                                    subtitle: Text(
                                                                        'A really nice subtitle'),
                                                                ),
                                                            ],
                                                        ),
                                                    );
                                                }).toList(),
                                            )

                                        ],
                                    );
                                }
                            );
                        }).toList(),
                    ),
                ),
            ),
        );
    }

    Widget _buildTabBar(BuildContext context) {
        return TabBar(
            isScrollable: true,
            tabs: List.generate(Plan.now().days.length,(index) {
                print(index);
                return Tab(
                    child: Column(
                        children: <Widget>[
                            Text(DateFormat.E().format(Plan.now().days[index].day)),
                            Text(DateFormat('d/M').format(Plan.now().days[index].day)),
                        ],
                    ),
                );
            }, growable: true),
        );
    }

    @override
    void initState() {
        super.initState();
    }
}
