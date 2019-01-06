import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/services/FontAwesome/FontAwesome.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/main.dart';
import 'package:MealEngineer/pages/AddRecipe.dart';

class MealSearch {
    static List<MealType> get values {
        List<MealType> values = [
            MealType('All', FontAwesomeIcons.utensilsSolid)
        ];
        values.addAll(MealType.values);
        return values;
    }
}

class RecipesPage extends Page {
    TabController tabController;
    FirebaseUser currentUser;

    RecipesPage(homeState) {
        tabController = TabController(length: MealSearch.values.length, vsync: homeState);
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
            //title: Text("Recipes"),
            title: TabBar(
                controller: tabController,
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
        return new FloatingActionButton(
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecipe(currentUser)
                    ),
                );
            },
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

    Stream<QuerySnapshot> recipeStream(MealType mealType) {
        var query = Firestore.instance.collection('users')
            .document(currentUser.uid).collection('recipes');

        if(mealType.name != 'All') {
            return query.where('mealType', arrayContains: mealType.name).snapshots();
        }

        return query.snapshots();
    }


    @override
    void initState() {
        super.initState();
    }


}
