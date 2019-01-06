import 'package:MealEngineer/Models/Recipe.dart';
import 'package:MealEngineer/services/FontAwesome/FontAwesome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

class Meal {
    String id;
    Recipe recipe;
    MealType mealType;
    DateTime day;

    DocumentReference reference;

    Meal(this.day, this.recipe, this.mealType);

    Meal.fromMap(Map<String, dynamic> map, this.id, DocumentSnapshot recipeSnapshot, {this.reference}) :
            assert(map['day'] != null),
            assert(map['mealType'] != null),
            assert(map['recipe'] != null),
            day = map['day'],
            mealType = MealType.values.firstWhere((mealType) => mealType.name == map['mealType']),
            recipe = Recipe.fromSnapshot(recipeSnapshot)
    ;

    Meal.fromSnapshot(DocumentSnapshot planSnapshot, DocumentSnapshot recipeSnapshot)
        : this.fromMap(planSnapshot.data, planSnapshot.documentID, recipeSnapshot, reference: planSnapshot.reference);

    @override
    String toString() {
        return 'Meal{day: $day}';
    }

    Future<DocumentReference> save(FirebaseUser user) {
      return Firestore.instance.collection('users')
          .document(user.uid).collection('plan')
          .add(this.toMap());
  }

    Map<String, dynamic> toMap() {
        return {
            'day' : day,
            'mealType' : mealType.name,
            'recipe' : recipe.reference,
        };
    }


}

class MealType {
    static final MealType breakfast = MealType(
        'Breakfast',
        FontAwesomeIcons.wheatSolid
    );
    static final MealType lunch = MealType(
        'Lunch',
        FontAwesomeIcons.drumstickBiteSolid
    );
    static final MealType dinner = MealType(
        'Dinner',
        FontAwesomeIcons.turkeySolid
    );
    static final MealType desert = MealType(
        'Desert',
        FontAwesomeIcons.birthdayCakeSolid
    );
    static final MealType snack = MealType(
        'Snack',
        FontAwesomeIcons.appleAltSolid
    );

    static final List<MealType> values = [
        breakfast,
        lunch,
        dinner,
        desert,
        snack
    ];

    final String name;
    final IconData icon;

    MealType(this.name, this.icon);

    @override
    String toString() {
        return name;
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is MealType &&
                runtimeType == other.runtimeType &&
                name == other.name;

    @override
    int get hashCode => name.hashCode;
}