import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Recipe {
    final String name;
    final DocumentReference reference;
    final String imageUrl;
    final int servings;
    final int cookTime;
    final int prepTime;

    Recipe.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['name'] != null),
            name = map['name'],
            imageUrl = map['image'],
            servings = map['servings'] ?? null,
            cookTime = map['cook_time'] ?? null,
            prepTime = map['prep_time'] ?? null;

    Recipe.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data, reference: snapshot.reference);

    @override
    String toString() => "Recipe<$name>";

    Widget get image {
        if(imageUrl == null) {
            return Icon(Icons.album);
        }
        return CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
        );
    }
}