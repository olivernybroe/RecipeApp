import 'package:MealEngineer/Models/Plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Recipe {
    String name;
    String description;
    String instructions;
    String id;

    DocumentReference reference;
    String imageUrl;
    int servings;
    int cookTime;
    int prepTime;
    List<String> ingredients = [];
    List<MealType> mealTypes = [];

    Recipe();

    Recipe.fromMap(Map<String, dynamic> map, this.id, {this.reference})
        : assert(map['name'] != null),
            name = map['name'],
            imageUrl = map['image'],
            servings = map['servings'] ?? null,
            cookTime = map['cook_time'] ?? null,
            prepTime = map['prep_time'] ?? null;

    Recipe.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

    @override
    String toString() => "Recipe<$name>";

    save(CollectionReference collection) {
        collection.add(this.toMap());
    }

    Map<String, dynamic> toMap() {
        return {
            'name' : name,
            'mealType' : mealTypes.map((MealType mealType) {
                return mealType.toString().substring(mealType.toString().indexOf('.')+1);
            }).toList(),
            'servings' : servings,
            'prep_time' : prepTime,
            'cook_time' : cookTime,
        };
    }


    Widget get image {
        if(imageUrl == null) {
            return Icon(Icons.album);
        }
        return CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
        );
    }
}