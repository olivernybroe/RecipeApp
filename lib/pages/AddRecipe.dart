
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:MealEngineer/Models/Plan.dart';
import 'package:MealEngineer/Models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



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

  bool _isExpanded = false;
  String _selected;
  HashMap<String, bool> _selected1 = HashMap<String, bool>();

  List<String> ingredients = [];
  List<TextFormField> _ingredientFields = [];
  List<Widget> _categories = [];

  File _image;

  void loadCategories() {
    _categories = [];
    for (MealType category in MealType.values) {
      String cat = category.name;
      _selected1.putIfAbsent(cat, () => false);

      _categories.add(new ListTile(
        leading: Checkbox(
            value: _selected1[cat],
            onChanged: (bool value) {
              setState(() {
                _selected1[cat] = value;
              });
            },
            key: Key(cat)),
        title: Text(cat),
      ));
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

            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpanded = !isExpanded;
                });
              },
              children: <ExpansionPanel>[
                new ExpansionPanel(
                  isExpanded: _isExpanded,
                  headerBuilder: (BuildContext context,
                      bool isExpanded) {
                    return TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Select a category',
                          prefixIcon: Icon(
                            Icons.category,
                          )
                      ),
                    );
                  },
                  body: Container(
                    child: Column(
                      children: _categories,
                    ),
                  ),
                )
              ],
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name of recipe',
                prefixIcon: Icon(
                  Icons.receipt,
                ),
              ),
              validator: (input) =>
              input.length == 0
                  ? 'Your recipe must have a name'
                  : null,
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
              onSaved: (input) =>
              _recipeModel.prepTime = (int.tryParse(input) ?? 0) * 60,
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
              onSaved: (input) =>
              _recipeModel.cookTime = (int.tryParse(input) ?? 0) * 60,
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
                ),
              ),
              //validator: (input) => input.length == 0 ? 'You must give a description of your recipe' : null,
              onSaved: (input) => _recipeModel.instructions = input,
            ),
/*
            RaisedButton(
              onPressed: () {
                _optionsDialogBox();
              },
            ),

            _image != null ? Image.file(_image) : Text('No image selected'),
*/
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
            onPressed: () {
              _submit(context);
            },
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

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Couldn't add validator to dropdown menu..
      if (_selected != null) {
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
      _ingredientFields.removeWhere((ingredientFields) =>
      ingredientFields.key == key);
    });
  }

  List<Widget> listIngredientFields() {
    return _ingredientFields;
  }
/*
  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      getImage();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    //onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openCamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _image = image;
    });
    debugPrint("hello");
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future openGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = image;
    });
  }
  */
}