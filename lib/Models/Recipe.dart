import 'package:MealEngineer/Models/Plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Recipe {
    String name;
    String description;
    String instructions;
    String id;

    DocumentReference reference;
    DocumentReference public;
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
            description = map['description'] ?? null,
            instructions = map['instructions'] != null ? (map['instructions'] as String).replaceAll(RegExp(r"\\n"), "\n") : null,
            ingredients = map['ingredients'] != null ? (map['ingredients'] as List).cast<String>() : null,
            prepTime = map['prep_time'] ?? null,
            mealTypes = List<String>.from(map['mealType'])
                .map((mealTypeString) => MealType.values.firstWhere((mealType) => mealType.name == mealTypeString))
                .toList(),
            public = map['public'] ?? null
    ;

    Recipe.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

    @override
    String toString() => "Recipe<$name>";

    save(CollectionReference collection) {
        collection.add(this.toMap());
    }

    Future<dynamic> publish(FirebaseUser user) {
        Map<String, dynamic> data = this.toMap();
        data['author'] = Firestore.instance.collection('users').document(user.uid);

        // If already published then update it.
        if(this.public != null) {
            return this.public.updateData(data);
        }

        return Firestore.instance.collection('recipes')
            .add(data)
            .then((ref) {
                this.reference.updateData({
                    'public' : ref
                });
            })
        ;
    }

    Future<dynamic> addToCookBook(FirebaseUser user) {
        return Firestore.instance.collection('users').document(user.uid)
            .collection('recipes')
            .add(this.toMap());
    }

    Map<String, dynamic> toMap() {
        return {
            'name' : name,
            'mealType' : mealTypes.map((MealType mealType) {
                return mealType.toString();
            }).toList(),
            'servings' : servings,
            'prep_time' : prepTime,
            'cook_time' : cookTime,
            'description' : description,
            'instructions' : instructions,
            'ingredients' : ingredients,
            'image' : imageUrl,
        };
    }


    ImageProvider get image {
        return imageUrl == null ? null : NetworkImage(imageUrl);
    }
}