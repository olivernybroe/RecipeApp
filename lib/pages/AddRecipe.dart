import 'package:flutter/material.dart';
import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/Models/RecipeV2.dart';
import 'dart:math';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _lastIngredientController = TextEditingController();

  RecipeV2 _recipeModel = new RecipeV2();

  String _selected;

  List<String> ingredients = [];
  List<TextFormField> _ingredientFields = [];
  List<DropdownMenuItem<String>> _categories = [];

  void loadCategories() {
    _categories = [];
    for (MealType category in MealType.values) {
      String cat =
          category.toString().substring(category.toString().indexOf('.') + 1);
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
                  //new Text('Select a category'),
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
                onSaved: (input) => _recipeModel.recipe = input,
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Short description',
                    prefixIcon: Icon(
                    Icons.subtitles,
                  ),
                ),
                validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => _recipeModel.description = input,
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
                validator: (input) => input.length == 0 ? 'You must provide an ingredient to your recipe' : null,
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
                validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => _recipeModel.cooking = input,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _submit,
                        child: Text('Create Recipe'),
                      ),
                  )
                ],
              ),
            ],
            ),
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your own recipe'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          addRecipeSection,
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Couldn't add validator to dropdown menu..
      if(_selected != null) {
        _recipeModel.category = _selected;
      }

      _recipeModel.save();
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
          validator: (input) => input.length == 0 ? 'You must provide an ingredient to your recipe' : null,
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
