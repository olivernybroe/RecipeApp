import 'package:flutter/material.dart';
import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/Models/Recipe.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  final formKey = GlobalKey<FormState>();

  String selected, recipe, description, cooking;  // TODO: Should be recipe.variables
  List<String> ingredients;                       // TODO: Should be recipe.ingredients

  List<TextFormField> ingredientFields = [];
  List<DropdownMenuItem<String>> categories = [];

  void loadCategories() {
    categories = [];
    for (MealType category in MealType.values) {
      String cat =
          category.toString().substring(category.toString().indexOf('.') + 1);
      categories.add(new DropdownMenuItem(
        child: new Text(cat),
        value: cat,
      ));
    }
  }

  Widget build(BuildContext context) {
    // Add Recipe form
    loadCategories();

    Widget addRecipeSection = Container(
      child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              DropdownButton(
                value: selected,
                items: categories,
                isExpanded: true,
                hint: new Text('Select a category'),
                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Name of recipe'),
                validator: (input) => input.length == 0 ? 'Your recipe must have a name' : null,
                onSaved: (input) => recipe = input,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Short description'),
                validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => description = input,
              ),

              // Retrieve list of ingredients
              Container(
                child: Column(
                  children: listIngredientFields(),
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ingredients',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addIngredient();
                      });
                    }),
                ),
                onSaved: (input) => input.length > 0 ? ingredients.add(input) : null,
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Recipe instructions'),
                validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
                onSaved: (input) => description = input,
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
          )
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
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      // TODO: Add everything to object instead of local variables, and push to firebase.
    }
  }

  void _addIngredient() {
    ingredientFields.add(
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Ingredients',
            prefixIcon: Icon(
              Icons.fastfood,
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    removeIngredient(22);
                  });
                  debugPrint('222');
                }),
          ),
          validator: (input) => input.length == 0 ? 'You must provide an ingredient to your recipe' : null,
          onSaved: (input) => ingredients.add(input),
        )
    );
  }

  void removeIngredient(key) {
    debugPrint(key.toString());
    // TODO: Figure out a way to remove a specific TextFormField object from a List.
  }

  List<Widget> listIngredientFields() {
    return ingredientFields;
  }
}
