import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/pages/AddRecipe.dart';
import 'package:MealEngineer/widgets/ChooseRecipe.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:intl/intl.dart';



class PlanPage extends Page {
    TabController tabController;
    FirebaseUser currentUser;

    PlanPage(homeState) {
        tabController = TabController(
            length: dates().length,
            vsync: homeState,
            initialIndex: 5
        );
        currentUser = homeState.currentUser;
    }

  @override
  BottomNavigationBarItem navigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        icon: Icon(Icons.event),
        title: Text('Plan')
    );
  }

    @override
    Widget floatingActionButton(BuildContext context) {
        return Builder(builder: (context) => FloatingActionButton(
            tooltip: 'Add recipe to the plan.',
            child: Icon(Icons.add),
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseRecipe(
                            context,
                            currentUser
                        ),
                    )
                ).then<Recipe>((recipe) {
                    SnackBar snackBar = SnackBar(
                        content: Text('Added ${recipe.name} to the plan.'),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);

                    Meal(dates().elementAt(tabController.index), recipe).save(currentUser);

                });
            },
        ));
    }

    @override
  Widget pageView(BuildContext context) {
    return _PlanPage(tabController, currentUser);
  }

  @override
  AppBar appBar(BuildContext context) {
      return AppBar(
          title: Builder(
            builder: (context) => TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: dates().map((DateTime datetime) {
                    return Tab(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Text(
                                    DateFormat.E().format(datetime),
                                ),
                                Text(
                                    DateFormat('d/M').format(datetime),
                                ),
                            ],
                        ),
                    );
                }).toList(),
            ),
          ),
      );
  }

  static List<DateTime> _dates;

  static List<DateTime> dates({int forward = 10, int past = 5}) {
      if(_dates != null) {
          return _dates;
      }

      DateTime now = DateTime.now();
      now = DateTime(
          now.year,
          now.month,
          now.day,
      );

      // Generate list of days in the past
      List<DateTime> days = List.generate(past, (index) =>
          now.subtract(Duration(days: index+1))
      ).reversed.toList();

      // Add current day to list
      days.add(now);

      // Then append a list of generated days in the future

      days.addAll(List.generate(forward, (index) =>
          now.add(Duration(days: index+1))
      ));

      return _dates = days;
  }

}

class _PlanPage extends StatefulWidget {
    final TabController _tabController;
    final FirebaseUser firebaseUser;

    _PlanPage(this._tabController, this.firebaseUser);

    @override
    State<StatefulWidget> createState() {
        return _PlanState(_tabController, firebaseUser);
    }

}

class _PlanState extends State<_PlanPage> with AutomaticKeepAliveClientMixin<_PlanPage>, SingleTickerProviderStateMixin {
    final TabController _tabController;
    final FirebaseUser currentUser;

    _PlanState(this._tabController, this.currentUser);

    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
        return TabBarView(
            controller: _tabController,
            children: PlanPage.dates().map((day) {
                return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users')
                        .document(currentUser.uid).collection('plan')
                        .where('day', isEqualTo: day)
                        .snapshots(),
                    builder: (context, mealSnapshot) {
                        if (!mealSnapshot.hasData) {
                            return Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 80.0,
                                    width: 80.0,
                                    child: CircularProgressIndicator(strokeWidth: 6.0,),
                                )
                            );
                        }

                        // Fetch all recipe streams.
                        Iterable<Future<DocumentSnapshot>> streamRecipes = mealSnapshot.data.documents
                            .map((snapshot) => snapshot.data['recipe'].get());

                        return FutureBuilder(
                            future: Future.wait(streamRecipes),
                            builder:(context, recipesSnapshot) {
                                if (!mealSnapshot.hasData) {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            child: CircularProgressIndicator(strokeWidth: 6.0,),
                                        )
                                    );
                                }

                                List<DocumentSnapshot> recipes = recipesSnapshot.data ?? [];

                                List<Meal> meals;
                                if(recipes.isEmpty) {
                                    meals = [];
                                } else {
                                    meals = mealSnapshot.data.documents
                                        .map((DocumentSnapshot snapshot) {

                                            try {
                                                DocumentSnapshot recipeSnapshot = recipes.firstWhere(
                                                        (recipe) => recipe.documentID == snapshot.data['recipe'].documentID,
                                                );


                                                return Meal.fromSnapshot(snapshot, recipeSnapshot);
                                            }
                                            catch(exception) {
                                                return null;
                                            }

                                    }).where((meal) => meal != null).toList();
                                }

                                return _buildList(
                                    context,
                                    day,
                                    meals
                                );
                            },
                        );
                    },
                );



            }).toList(),
        );
    }

    Widget _buildList(BuildContext context, DateTime day, List<Meal> meals) {
        if(meals.isEmpty) {
            return Align(
                alignment: Alignment.center,
                child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: Text(
                        "Press the icon in the right bottom corner to add a recipe to the plan.",
                        style: TextStyle(color: Colors.black45),
                    )
                )
            );
        } else {
            return Column(
                children: meals.map((data) => _buildListItem(context, data)).toList(),
            );
        }
    }

    Widget _buildListItem(BuildContext context, Meal meal) {
        return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(meal.id),
            background: Container(
                color: Colors.redAccent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        Text("REMOVE", style: TextStyle(color: Colors.white),),
                        Padding(padding: EdgeInsets.all(8.0),),
                        Icon(Icons.delete, color: Colors.white,),
                        Padding(padding: EdgeInsets.all(8.0),),
                    ],
                ),
            ),
            child: RecipeCard(
                context,
                meal.recipe,
                currentUser: currentUser,
            ),
            onDismissed: (DismissDirection direction) {
                meal.reference.delete();
            },
        );
    }

}
