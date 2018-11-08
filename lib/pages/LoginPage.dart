import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MealEngineer/Models/Recipe.dart';



final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(


      body: Center(


        child: new Column(
          children: <Widget>[

            Text(
              'Recipe App',
              style: TextStyle(decoration: TextDecoration.underline),
            ),

            new RaisedButton(
                child: new Text('Login with Google'),
                onPressed: () {
                  _handleSignIn()
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) => print(e));
                }
            ),
          ],
        ),
      ),
    );
  }


      /*Container(
      decoration: BoxDecoration(color: Colors.blue[500]),
        child: Center(
          child:
            new RaisedButton(
              child: new Text('Login with Google'),
                onPressed: () {
              _handleSignIn()
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e));
            }),
        )
    );*/


  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }
}