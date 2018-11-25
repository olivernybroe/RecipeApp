import 'package:MealEngineer/Models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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
                    Recipe.fromMap({'name' : 'test'}),
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

enum MealType {
    Breakfast,
    Lunch,
    Dinner,
    Desert,
    Snack
}

class Meal {
    Recipe recipe;
    MealType mealType;

    Meal(this.recipe, this.mealType);
}