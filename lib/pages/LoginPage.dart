import 'package:MealEngineer/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _handleGoogleSignIn()
                    .then((FirebaseUser user) => print(user))
                    .catchError((e) => print(e));
              },
            ),
            RaisedButton(
                child: Text('Continue without login'),
                onPressed: () => _handleAnonymousSignIn(),
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _handleAnonymousSignIn() async {
    FirebaseUser user = await auth.signInAnonymously();
    return user;
  }

  Future _handleSignOut() async {
    await googleSignIn.signOut();
    return auth.signOut();
  }
}
