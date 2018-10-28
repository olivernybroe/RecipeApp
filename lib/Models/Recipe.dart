import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
    final String name;
    final DocumentReference reference;

    Recipe.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['name'] != null), name = map['name'];

    Recipe.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data, reference: snapshot.reference);

    @override
    String toString() => "Recipe<$name>";
}