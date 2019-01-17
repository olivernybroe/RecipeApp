import 'dart:collection';

import 'package:MealEngineer/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



class ShoppingListPage extends Page {
    FirebaseUser currentUser;
    HomeState homeState;
    _ShoppingList selectedValue;
    Stream<QuerySnapshot> shoppingListStream;

    ShoppingListPage(HomeState homeState) {
        currentUser = homeState.currentUser;
        this.homeState = homeState;

        shoppingListStream =Firestore.instance.collection('users')
            .document(currentUser.uid).collection('shoppingList')
            .snapshots();
    }

  @override
  BottomNavigationBarItem navigationBarItem(BuildContext context) {
      return BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Shopping List')
      );
  }

  @override
  Widget pageView(BuildContext context) {
      return _ShoppingListPage(this);
  }

    @override
    AppBar appBar(BuildContext context) {
        return AppBar(
            centerTitle: true,
            actions: appBarActions(context),
            title: Text('Shopping list'),
        );
    }
}

class _ShoppingList {
    String id;
    String name;
    List<_Item> checked;
    List<_Item> unchecked;

    DocumentReference reference;

    _ShoppingList(this.name, this.checked, this.unchecked);

    _ShoppingList.fromMap(Map<String, dynamic> map, this.id, {this.reference}) :
            assert(map['name'] != null),
            name = map['name'],
            unchecked = map['unchecked'] != null ? _Item.fromList(List<String>.from(map['unchecked'])) : [],
            checked = map['checked'] != null ? _Item.fromList(List<String>.from(map['checked'])) : []
    ;

    _ShoppingList.fromSnapshot(DocumentSnapshot shoppingListSnapshot)
        : this.fromMap(shoppingListSnapshot.data, shoppingListSnapshot.documentID, reference: shoppingListSnapshot.reference);


    _ShoppingList.example(FirebaseUser user) {
        name = "Shopping list";
        checked = [
            _Item(0, '1kg potatos')
        ];
        unchecked = [
            _Item(1, '2kg carrots'),
            _Item(2, '2pck bread')
        ];

        Firestore.instance.collection('users')
            .document(user .uid).collection('shoppingList').add(toMap())
            .then((ref) => reference = ref);

    }

    Map<String, dynamic> toMap() => {
        'name' : name,
        'checked' : checked.map((item) => item.toString()).toList(),
        'unchecked' : unchecked.map((item) => item.toString()).toList()
    };

    Future<void> update() => reference.updateData(toMap());

    @override
    String toString() => '$name';

    _Item addItem(String value) {
        _Item item = _Item(
            this.unchecked.reduce((first, second) => first.index > second.index ? first : second).index,
            value
        );
        this.unchecked.add(item);
        return item;
    }
}

class _Item {
    int index;
    String value;

    _Item(this.index, this.value);

    static List<_Item> fromList(List<String> stringList) {
        List<_Item> items = [];

        for (var i = 0; i < stringList.length; ++i) {
            var o = stringList[i];
            items.add(_Item(i, o));
        }

        return items;
    }

    @override
    String toString() {
        return '$value';
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is _Item &&
                runtimeType == other.runtimeType &&
                index == other.index &&
                value == other.value;

    @override
    int get hashCode =>
        index.hashCode ^
        value.hashCode;
}


class _ShoppingListPage extends StatefulWidget {
    final ShoppingListPage page;

    _ShoppingListPage(this.page);

    @override
    State<StatefulWidget> createState() {
        return _ShoppingListState(page);
    }
}


class _ShoppingListState extends State<_ShoppingListPage> {
    final ShoppingListPage page;
    bool addItem = false;
    FocusNode myFocusNode;

    _ShoppingListState(this.page);

    @override
    void initState() {
        super.initState();

        myFocusNode = FocusNode();
    }

    @override
    void dispose() {
        // Clean up the focus node when the Form is disposed
        myFocusNode.dispose();

        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: StreamBuilder<QuerySnapshot>(
                stream: page.shoppingListStream,
                builder: (context, shoppingListSnapshot) {
                    if (!shoppingListSnapshot.hasData) {
                        return Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 80.0,
                                width: 80.0,
                                child: CircularProgressIndicator(strokeWidth: 6.0,),
                            )
                        );
                    }

                    List<_ShoppingList> shoppingLists = shoppingListSnapshot.data.documents.map(
                            (document) => _ShoppingList.fromSnapshot(document)
                    ).toList();

                    _ShoppingList list;
                    try {
                        list = page.selectedValue ?? shoppingLists.first;
                    }
                    catch(exception) {
                        list = _ShoppingList.example(page.currentUser);
                    }

                    // Create an array of items from the shopping list.
                    List<Widget> items = list.unchecked.map(
                            (item) => buildItem(list, item)
                    ).toList();


                    // Add the create item field to the shopping list.
                    items.add(GestureDetector(
                        onTap: () {
                            setState(() {
                                list.update();
                                addItem = true;
                            });
                        },
                        child: Builder(builder: (context) {
                            if(addItem == true) {
                                _Item item = list.addItem("");
                                editItem = item;
                                return buildItem(
                                    list,
                                    item,
                                    onSubmitted: (value) {
                                        setState(() {
                                          addItem = false;
                                        });
                                    },
                                    onDelete: () {
                                        setState(() {
                                          addItem = false;
                                        });
                                    },
                                    canBeEdited: true,
                                );
                            }

                            return ListTile(
                                isThreeLine: false,
                                leading: Icon(Icons.add),
                                title: Text(
                                    "Add item",
                                    style: TextStyle(color: Colors.black26),
                                ),
                            );
                        }),
                    ));


                    return ListView(
                        children: items,
                    );
                },
            ),
        );
    }

    _Item editItem;

    Widget buildItem(
        _ShoppingList list,
        _Item item,
        {
            ValueChanged<String> onSubmitted,
            FocusNode focusNode,
            bool canBeEdited = false,
            VoidCallback onDelete,
        }
    ) {
        focusNode = focusNode ?? myFocusNode;
        bool editable = (editItem == item && addItem == false) || canBeEdited;

        return ListTile(
            leading: Checkbox(
                value: false,
                onChanged: (value) {
                    list.unchecked.remove(item);
                    list.checked.add(item);
                    list.update();
                },
            ),
            title: GestureDetector(
                onTap: () {
                    print("tapped");
                    setState(() {
                        editItem = item;
                    });
                },
                child: Builder(builder: (context) {
                    if(editable == true) {
                        TextEditingController controller = TextEditingController();
                        controller.text = item.value;
                        return TextField(
                            focusNode: focusNode,
                            controller: controller,
                            onSubmitted: (value) {
                                focusNode.unfocus();
                                item.value = value;
                                list.update();
                                onSubmitted(value);
                            },
                        );
                    }

                    return Text(item.value);
                }),
            ),
            trailing: Builder(builder: (context) {
                if(editable == true) {
                    return IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                            list.unchecked.remove(editItem);
                            list.update();
                            onDelete();
                        }
                    );
                }
                return Container(width: 0, height: 0,);
            }),
        );


    }
}
