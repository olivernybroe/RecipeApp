import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/pages/AddRecipe.dart';

class MealSearch {
    static List<String> get values {
        List<String> values = ['All'];
        values.addAll(MealType.values.map((MealType mealType) {
            return mealType.toString().substring(mealType.toString().indexOf('.')+1);
        }));
        return values;
    }
}

class RecipesPage extends Page {
    TabController tabController;
    FirebaseUser currentUser;

    RecipesPage(homeState) {
        tabController = new TabController(length: MealSearch.values.length, vsync: homeState);
        currentUser = homeState.currentUser;
    }

    Widget pageView(BuildContext context) {
        return _RecipesPage(currentUser, tabController);
    }

    @override
    BottomNavigationBarItem navigationBarItem(BuildContext context) {
        return BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Recipes')
        );
    }

    @override
    AppBar appBar(BuildContext context) {
        return new AppBar(
            bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: MealSearch.values.map((String mealType) {
                    return Tab(
                        child: Column(
                            children: <Widget>[
                                Text(mealType)
                            ],
                        ),
                    );
                }).toList()
            ),
        );
    }

    @override
    Widget floatingActionButton(BuildContext context) {
        return new FloatingActionButton(
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRecipe()),
                );
            },,
            tooltip: 'Create a recipe',
            child: new Icon(Icons.add),
        );
    }


}

class _RecipesPage extends StatefulWidget {
    final TabController tabController;
    final FirebaseUser firebaseUser;

    _RecipesPage(this.firebaseUser, this.tabController);

    @override
    State<StatefulWidget> createState() {
        return _RecipeState(firebaseUser, tabController);
    }
}

class _RecipeState extends State<_RecipesPage> with AutomaticKeepAliveClientMixin<_RecipesPage> {
    final TabController tabController;
    final FirebaseUser currentUser;

    _RecipeState(this.currentUser, this.tabController);


    @override
    bool get wantKeepAlive => true;

    final Stream<FirebaseUser> userStream = auth.currentUser().asStream();

    @override
    Widget build(BuildContext context) {
        return TabBarView(
            controller: tabController,
            children: MealSearch.values.map((String mealType) {
                //return Text(mealType.toString());
                return _buildBody(context, mealType);
            }).toList()
        );
    }

    Widget _buildBody(BuildContext context, String mealType) {
        return StreamBuilder<QuerySnapshot>(
            stream: recipeStream(mealType),
            builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

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
        return RecipeCard(recipe);
    }

    Stream<QuerySnapshot> recipeStream(String mealType) {
        var query = Firestore.instance.collection('users')
            .document(currentUser.uid).collection('recipes');

        if(mealType != 'All') {
            return query.where('mealType', arrayContains: mealType).snapshots();
        }

        return query.snapshots();
    }


    @override
    void initState() {
        super.initState();
    }


}
