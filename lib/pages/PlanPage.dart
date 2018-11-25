import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:intl/intl.dart';



class PlanPage extends Page {

    TabController tabController;

    PlanPage(TickerProvider tickerProvider) {
        tabController = new TabController(
            length: Plan.now().days.length,
            vsync: tickerProvider,
            initialIndex: 1
        );
    }

  @override
  BottomNavigationBarItem navigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        icon: Icon(Icons.event),
        title: Text('Plan')
    );
  }

  @override
  Widget pageView(BuildContext context) {
    return _PlanPage(tabController);
  }

  @override
  AppBar appBar(BuildContext context) {

      return AppBar(
          bottom: TabBar(
              controller: tabController,
              isScrollable: true,
              tabs: List.generate(Plan.now().days.length,(index) {
                  return Tab(
                      child: Column(
                          children: <Widget>[
                              Text(DateFormat.E().format(Plan.now().days[index].day)),
                              Text(DateFormat('d/M').format(Plan.now().days[index].day)),
                          ],
                      ),
                  );
              }, growable: true),
          ),
      );
  }


}

class _PlanPage extends StatefulWidget {
    final TabController _tabController;

    _PlanPage(this._tabController);

    @override
    State<StatefulWidget> createState() {
        return _PlanState(_tabController);
    }

}

class _PlanState extends State<_PlanPage> with AutomaticKeepAliveClientMixin<_PlanPage>, SingleTickerProviderStateMixin {
    final TabController _tabController;

    _PlanState(this._tabController);

    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
        return TabBarView(
            controller: _tabController,
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
                                        return RecipeCard(meal.recipe);
                                    }).toList(),
                                )

                            ],
                        );
                    }
                );
            }).toList(),
        );
    }

    Widget _buildTabBar() {
        return TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: List.generate(Plan.now().days.length,(index) {
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
