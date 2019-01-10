import 'dart:async';

import 'package:MealEngineer/pages/LoginPage.dart';
import 'package:MealEngineer/pages/PlanPage.dart';
import 'package:MealEngineer/pages/ShoppingListPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MealEngineer/pages/RecipesPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/pages/SplashPage.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
    bool isInDebugMode = false;
    profile((){
        isInDebugMode=true;
    });

    FlutterError.onError = (FlutterErrorDetails details) {
        if (isInDebugMode) {
            // In development mode simply print to console.
            FlutterError.dumpErrorToConsole(details);
        } else {
            // In production mode report to the application zone to report to
            // Crashlytics.
            Zone.current.handleUncaughtError(details.exception, details.stack);
        }
    };

    bool optIn = true;
    if (optIn) {
        await FlutterCrashlytics().initialize();
    } else {
        // In this case Crashlytics won't send any reports.
        // Usually handling opt in/out is required by the Privacy Regulations
    }

    runZoned<Future<Null>>(() async {
        runApp(MyApp());
    }, onError: (error, stackTrace) async {
        // Whenever an error occurs, call the `reportCrash` function. This will send
        // Dart errors to our dev console or Crashlytics depending on the environment.
        debugPrint(error.toString());
        await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
    });
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: '',
            home: _handleCurrentScreen(),
            theme: ThemeData(
                indicatorColor: Colors.white70,
                // Define the default Brightness and Colors
                brightness: Brightness.light,
                primaryColor: Color.fromRGBO(130,187,60, 1.0),
                //accentColor: Color.fromRGBO(110, 96, 87, 1.0),

                // Define the default Font Family
                fontFamily: 'Montserrat',
                tabBarTheme: TabBarTheme(
                    labelColor: Colors.white70,
                ),

                iconTheme: IconThemeData(
                    //color: Colors.white70
                ),
                primaryIconTheme: IconThemeData(
                    color: Colors.white70//Color.fromRGBO(81, 139, 0, 1.0),
                ),

                accentIconTheme: IconThemeData(
                    color: Colors.white70,
                ),

                accentColor: Color.fromRGBO(130,187,60, 1.0),

                buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary
                ),


                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: TextTheme(
                    headline: TextStyle(
                        fontSize: 72.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                    ),
                    title: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                    ),

                    body1: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Hind',
                    ),
                ),
                primaryTextTheme: TextTheme(
                    headline: TextStyle(
                        fontSize: 72.0,
                        fontWeight: FontWeight.bold
                    ),
                    title: TextStyle(color: Colors.white70),
                    body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                ),
            ),
        );
    }

    Widget _handleCurrentScreen() {
        return StreamBuilder<FirebaseUser>(
            stream: auth.onAuthStateChanged,
            builder: (BuildContext context, snapshot) {
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return SplashPage();
                } else {
                    if (snapshot.hasData) {
                        return Home(snapshot.data);
                    }
                    return LoginPage();
                }
            }
        );
    }
}

class Home extends StatefulWidget {
    FirebaseUser currentUser;

    Home(this.currentUser);

    @override
  State<StatefulWidget> createState() {
      return HomeState(currentUser);
  }
}

abstract class Page {
    Widget pageView(BuildContext context);

    BottomNavigationBarItem navigationBarItem(BuildContext context);

    AppBar appBar(BuildContext context) {
        return AppBar(
            actions: appBarActions(context),
        );
    }

    Widget floatingActionButton(BuildContext context) {
        return null;
    }

    List<Widget> appBarActions(BuildContext context) {
        return <Widget>[
            PopupMenuButton(
                onSelected: (value) {
                    if(value == 'Log out') {
                        FirebaseAuth.instance.signOut();
                    }
                },
                itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "Log out",
                        child: Text("Log out")
                    )
                ]
            ),
        ];
    }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
    PageController _pageController;
    FirebaseUser currentUser;

    int _page = 0;

    List pages;

    HomeState(this.currentUser) {
        pages = [
            RecipesPage(this),
            PlanPage(this),
            ShoppingListPage(),
        ];
    }


  @override
  Widget build(BuildContext context) {
      var currentPage = pages[_page];

      return Scaffold(
          appBar: currentPage.appBar(context),
          floatingActionButton: currentPage.floatingActionButton(context),
          body: PageView(
              children: pages.map((page) {
                  return Container(
                      child: SafeArea(
                          child: page.pageView(context)
                      ),
                  );
              }).toList(),

              controller: _pageController,
              onPageChanged: onPageChanged
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: pages.map((page) {
                  return page.navigationBarItem(context) as BottomNavigationBarItem;
              }).toList(),
              onTap: navigationTapped,
              currentIndex: _page,
          ),

      );
  }

    void onPageChanged(int page){
        setState((){
            this._page = page;
        });
    }

    /// Called when the user presses on of the
    /// [BottomNavigationBarItem] with corresponding
    /// page index
    void navigationTapped(int page){

        // Animating to the page.
        // You can use whatever duration and curve you like
        _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease
        );
    }

    @override
    void initState() {
        super.initState();
        initializeDateFormatting();

        _pageController = PageController();
    }

    @override
    void dispose(){
        super.dispose();
        _pageController.dispose();
    }
}
