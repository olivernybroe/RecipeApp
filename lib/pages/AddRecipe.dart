import 'package:MealEngineer/Models/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MealEngineer/Models/Plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AddRecipe extends StatefulWidget {
  final FirebaseUser currentUser;

  AddRecipe(this.currentUser);

  @override
  _AddRecipeState createState() => _AddRecipeState(this.currentUser);
}

class _AddRecipeState extends State<AddRecipe> {

  final FirebaseUser currentUser;

  _AddRecipeState(this.currentUser);

  final _formKey = GlobalKey<FormState>();
  final _lastIngredientController = TextEditingController();

  Recipe _recipeModel = Recipe();

  String _selected;

  List<String> ingredients = [];
  List<TextFormField> _ingredientFields = [];
  List<DropdownMenuItem<String>> _categories = [];

  void loadCategories() {
    _categories = [];
    for (MealType category in MealType.values) {
      String cat = category.name;
      _categories.add(new DropdownMenuItem(
        value: cat,
        child:
          new Text(cat),
        )
      );
    }
  }

  Widget build(BuildContext context) {
    // Add Recipe form
    loadCategories();

    Widget addRecipeSection = Container(
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.category,
                  ),
                ),
                child:
                DropdownButton(
                  value: _selected,
                  items: _categories,
                  //isExpanded: true,
                  hint:
                  Row(
                    children: <Widget>[
                      new Text('Select a category'),
                    ],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selected = value;
                    });
                  },
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Name of recipe',
                    prefixIcon: Icon(
                    Icons.receipt,
                  ),
                ),
                validator: (input) => input.length == 0 ? 'Your recipe must have a name' : null,
                onSaved: (input) => _recipeModel.name = input,
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Short description',
                    prefixIcon: Icon(
                    Icons.subtitles,
                  ),
                ),
                //validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => _recipeModel.description = input,
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: '# of serverings',
                  prefixIcon: Icon(Icons.person)
                ),
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false
                ),
                onSaved: (input) => _recipeModel.servings = int.tryParse(input),
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Prep time in minutes',
                    prefixIcon: Icon(Icons.access_time)
                ),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false
                ),
                onSaved: (input) => _recipeModel.prepTime = (int.tryParse(input) ?? 0)*60,
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Cook time in minutes',
                    prefixIcon: Icon(Icons.access_time)
                ),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false
                ),
                onSaved: (input) => _recipeModel.cookTime = (int.tryParse(input) ?? 0)*60,
              ),

              // Retrieve list of ingredients
              Container(
                child: Column(
                  children: listIngredientFields(),
                ),
              ),

              TextFormField(
                controller: _lastIngredientController,
                decoration: InputDecoration(
                  labelText: 'Ingredient',
                  prefixIcon: Icon(
                    Icons.fastfood,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addIngredient(_lastIngredientController.text);
                        _lastIngredientController.text = '';
                      });
                    }),
                ),
                //validator: (input) => input.length == 0 ? 'You must provide an ingredient to your recipe' : null,
                onSaved: (input) => _recipeModel.ingredients.add(input),
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Recipe instructions',
                    prefixIcon: Icon(
                    Icons.description,
                  ),),
                //validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => _recipeModel.instructions = input,
              ),
            ],
            ),
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add your own recipe',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () {_submit(context);},
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          addRecipeSection,
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Couldn't add validator to dropdown menu..
      if(_selected != null) {
        _recipeModel.mealTypes.add(
            MealType.values.firstWhere((mealType) => mealType.name == _selected)
        );
      }
      _recipeModel.save(
          Firestore.instance.collection('users')
              .document(currentUser.uid).collection('recipes')
      );

      Navigator.pop(context);
    }
  }

  void _addIngredient(value) {
    Random rnd = new Random();
    Key key = new Key(rnd.nextInt(10000).toString());
    _ingredientFields.add(
        TextFormField(
          initialValue: value,
          key: key,
          decoration: InputDecoration(
            labelText: 'Ingredient',
            prefixIcon: Icon(
              Icons.fastfood,
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    removeIngredient(key);
                  });
                }),
          ),
          //validator: (input) => input.length == 0 ? 'You must provide an ingredient to your recipe' : null,
          onSaved: (input) => _recipeModel.ingredients.add(input),
        )
    );
  }

  void removeIngredient(key) {
    setState(() {
      _ingredientFields.removeWhere((ingredientFields) => ingredientFields.key == key);
    });
  }

  List<Widget> listIngredientFields() {
    return _ingredientFields;
  }
}
