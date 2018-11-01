import 'package:MealEngineer/Models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
           return Day(now.subtract(Duration(days: index+1)));
        });

        // Add current day to list
        days.add(Day(now));

        // Then append a list of generated days in the future

        days.addAll(List.generate(forward, (index) {
            return Day(now.add(Duration(days: index+1)));
        }));

        return _now = Plan(days);
    }
}

class Day {
    DateTime day;
    List<Meal> meals;

    Day(this.day);


}

class Meal {
    Recipe recipe;
}