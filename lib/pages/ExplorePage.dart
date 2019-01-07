import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';


class ExplorePage extends Page {
    TabController tabController;
    FirebaseUser currentUser;

    ExplorePage(homeState) {
        tabController = TabController(length: MealSearch.values.length, vsync: homeState);
        currentUser = homeState.currentUser;
    }

    @override
    BottomNavigationBarItem navigationBarItem(BuildContext context) {
      return BottomNavigationBarItem(
          icon: Icon(Icons.public),
          title: Text("Explore"),
      );
    }

    @override
    Widget pageView(BuildContext context) {
      return _ExplorePage(currentUser, tabController);
    }

    @override
    AppBar appBar(BuildContext context) {
        return AppBar(
            //title: Text("Explore"),
            title: Center(
                child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabs: MealSearch.values.map((MealType mealType) =>
                        Tab(
                            icon: Icon(
                                mealType.icon,
                            ),
                        )).toList()
                ),
            ),
        );
    }
}


class _ExplorePage extends StatefulWidget {
    final TabController tabController;
    final FirebaseUser firebaseUser;

    _ExplorePage(this.firebaseUser, this.tabController);

    @override
    State<StatefulWidget> createState() {
        return _ExploreState(this.firebaseUser, this.tabController);
    }
}


class _ExploreState extends State<_ExplorePage> {
    final TabController tabController;
    final FirebaseUser currentUser;

    _ExploreState(this.currentUser, this.tabController);

    @override
    Widget build(BuildContext context) {
        return TabBarView(
            controller: tabController,
            children: MealSearch.values.map((MealType mealType) {
                return _buildBody(context, mealType);
            }).toList()
        );
    }

    Widget _buildBody(BuildContext context, MealType mealType) {
        return StreamBuilder<QuerySnapshot>(
            stream: recipeStream(mealType),
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
        return RecipeCard.public(
            context,
            recipe,
            currentUser,
        );
    }

    Stream<QuerySnapshot> recipeStream(MealType mealType) {
        var query = Firestore.instance.collection('recipes');

        if(mealType.name != 'All') {
            return query.where('mealType', arrayContains: mealType.name).snapshots();
        }

        return query.snapshots();
    }
}
