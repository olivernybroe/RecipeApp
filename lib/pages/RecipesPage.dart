import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/main.dart';

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

    RecipesPage(TickerProvider tickerProvider) {
        tabController = new TabController(length: MealSearch.values.length, vsync: tickerProvider);
    }

    Widget pageView(BuildContext context) {
        return _RecipesPage(tabController);
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
            onPressed: null,
            tooltip: 'Create a recipe',
            child: new Icon(Icons.add),
        );
    }


}

class _RecipesPage extends StatefulWidget {
    final TabController tabController;

    _RecipesPage(this.tabController);

    @override
    State<StatefulWidget> createState() {
        return _RecipeState(tabController);
    }
}

class _RecipeState extends State<_RecipesPage> with AutomaticKeepAliveClientMixin<_RecipesPage> {
    final TabController tabController;

    _RecipeState(this.tabController);


    @override
    bool get wantKeepAlive => true;

    Stream<FirebaseUser> userStream;

    @override
    Widget build(BuildContext context) {
        return TabBarView(
            controller: tabController,
            children: MealSearch.values.map((String mealType) {
                //return Text(mealType.toString());
                return _buildBody(context);
            }).toList()
        );
    }

    Widget _buildBody(BuildContext context) {
        return StreamBuilder(
            stream: userStream,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();

                return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').document(snapshot.data.uid).collection('recipes').snapshots(),
                    builder: (context, snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();

                        return _buildList(context, snapshot.data.documents);
                    },
                );
            }
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

    @override
    void initState() {
        super.initState();
        userStream = auth.currentUser().asStream();
    }


}
