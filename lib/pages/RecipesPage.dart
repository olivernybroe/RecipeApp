import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/services/FontAwesome/FontAwesome.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/pages/AddRecipe.dart';

class RecipesPage extends Page {
    TabController favoriteTabController;
    TabController publicityTabController;
    FirebaseUser currentUser;

    RecipesPage(HomeState homeState) {
        favoriteTabController = TabController(length: MealSearch.values.length, vsync: homeState);
        publicityTabController = TabController(length: 2, vsync: homeState);
        currentUser = homeState.currentUser;
    }

    Widget pageView(BuildContext context) {
        return _RecipesPage(currentUser, favoriteTabController, publicityTabController);
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
        return AppBar(
            actions: appBarActions(context),
            centerTitle: true,
            title: TabBar(
                indicatorPadding: EdgeInsets.all(8),
                controller: publicityTabController,
                tabs: [
                    FlatButton(
                        onPressed: null,
                        child: Text('Favorites', style: Theme.of(context).textTheme.title)
                    ),
                    FlatButton(
                        onPressed: null,
                        child: Text('Public', style: Theme.of(context).textTheme.title)
                    ),
                ]
            ),
            bottom: TabBar(
                controller: favoriteTabController,
                isScrollable: true,
                tabs: MealSearch.values.map((MealType mealType) {
                    return Tab(
                        icon: Icon(
                            mealType.icon,
                        ),
                    );
                }).toList()
            ),
        );
    }

    @override
    Widget floatingActionButton(BuildContext context) {
        return FloatingActionButton(
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecipe(currentUser)
                    ),
                );
            },
            tooltip: 'Create a recipe',
            child: Icon(Icons.add),
        );
    }
}

class _RecipesPage extends StatefulWidget {
    TabController favoriteTabController;
    TabController publicityTabController;
    final FirebaseUser firebaseUser;

    _RecipesPage(this.firebaseUser, this.favoriteTabController, this.publicityTabController);

    @override
    State<StatefulWidget> createState() {
        return _RecipeState(firebaseUser, favoriteTabController, publicityTabController);
    }
}

class _RecipeState extends State<_RecipesPage> with AutomaticKeepAliveClientMixin<_RecipesPage> {
    TabController favoriteTabController;
    TabController publicityTabController;
    final FirebaseUser currentUser;

    _RecipeState(this.currentUser, this.favoriteTabController, this.publicityTabController);


    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {

        return TabBarView(
            controller: publicityTabController,
            children: <Widget>[
                TabBarView(
                    controller: favoriteTabController,
                    children: MealSearch.values.map((MealType mealType) {
                        return _buildBody(
                            context,
                            recipeStream(mealType, false),
                            false
                        );
                    }).toList()
                ),
                TabBarView(
                    controller: favoriteTabController,
                    children: MealSearch.values.map((MealType mealType) {
                        return _buildBody(
                            context,
                            recipeStream(mealType, true),
                            true
                        );
                    }).toList()
                ),
            ],
        );
    }

    Widget _buildBody(BuildContext context, Stream<QuerySnapshot> query, bool public) {
        return StreamBuilder<QuerySnapshot>(
            stream: query,
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

                return _buildList(context, snapshot.data.documents, public);
            },
        );
    }

    Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, bool public) {
        return ListView(
            children: snapshot.map((data) => _buildListItem(context, data, public)).toList(),
        );
    }

    Widget _buildListItem(BuildContext context, DocumentSnapshot data, bool public) {
        final recipe = Recipe.fromSnapshot(data);
        if(public == false) {
            return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(recipe.id),
                background: Container(
                    color: Colors.redAccent,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                            Text("DELETE", style: TextStyle(color: Colors.white),),
                            Padding(padding: EdgeInsets.all(8.0),),
                            Icon(Icons.delete, color: Colors.white,),
                            Padding(padding: EdgeInsets.all(8.0),),
                        ],
                    ),
                ),
                child: RecipeCard(
                    context,
                    recipe,
                    currentUser: currentUser,
                ),
                onDismissed: (DismissDirection direction) {
                    recipe.reference.delete();
                },
            );
        }

        return RecipeCard.public(
            context,
            recipe,
            currentUser,
        );
    }

    Stream<QuerySnapshot> recipeStream(MealType mealType, bool public) {
        CollectionReference query;

        if(public == false) {
            query = Firestore.instance.collection('users')
                .document(currentUser.uid).collection('recipes');
        } else {
            query = Firestore.instance.collection('recipes');
        }

        if(mealType.name != 'All') {
            return query.where('mealType', arrayContains: mealType.name).snapshots();
        }

        return query.snapshots();
    }
}
