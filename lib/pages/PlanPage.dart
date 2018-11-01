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
                        children: List.generate(Plan.now().days.length, (index) {
                            return  Column(
                                children: <Widget>[
                                    Text(DateFormat.E().format(Plan.now().days[index].day)),
                                    Text(DateFormat('d/M').format(Plan.now().days[index].day)),
                                ],
                            );
                        }),
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
                            Text(
                                DateFormat('d/M').format(Plan.now().days[index].day),
                                style: TextStyle(
                                    fontSize: 8.0
                                ),
                            ),
                        ],
                    ),
                   //text: DateFormat.E().format(Plan.now().days[index].day) //tabNames[Plan.now().days[index].day.weekday-1]
                );
            }, growable: true),
        );
    }

    @override
    void initState() {
        super.initState();
    }
}
