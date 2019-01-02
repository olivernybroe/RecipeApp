import 'package:MealEngineer/Models/Recipe.dart';
import 'package:MealEngineer/services/FontAwesome/FontAwesome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

class Plan {
    List<Day> days;

    Plan(this.days);


    static Plan _now;

    static Plan now({int forward = 5, int past = 1})
    {
        if(_now != null) {
            return _now;
        }

        var now = DateTime.now();

        // Generate list of days in the past
        List<Day> days = List.generate(past, (index) {
           return randomDay(now.subtract(Duration(days: index+1)));
        });

        // Add current day to list
        days.add(randomDay(now));

        // Then append a list of generated days in the future

        days.addAll(List.generate(forward, (index) {
            return randomDay(now.add(Duration(days: index+1)));

        }));

        return _now = Plan(days);
    }

    static Day randomDay(DateTime now) {
        return Day(
            now,
            List.generate(Random().nextInt(10), (index) {
                return Meal(
                    Recipe.fromMap({'name' : 'test'}, "works"),
                    MealType.values[index % 3]
                );
            })
        );
    }
}

class Day {
    DateTime day;
    List<Meal> meals;

    Day(this.day, this.meals);
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

class Meal {
    Recipe recipe;
    MealType mealType;

    Meal(this.recipe, this.mealType);
}