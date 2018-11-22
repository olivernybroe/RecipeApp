import 'package:MealEngineer/pages/ExplorePage.dart';
import 'package:MealEngineer/pages/LoginPage.dart';
import 'package:MealEngineer/pages/PlanPage.dart';
import 'package:MealEngineer/pages/ShoppingListPage.dart';
import 'package:flutter/material.dart';
import 'package:MealEngineer/pages/RecipesPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MealEngineer/pages/SplashPage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: '',
            home: _handleCurrentScreen()
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
                        return Home();
                    }
                    return LoginPage();
                }
            }
        );
    }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
      return _HomeState();
  }
}

class _HomeState extends State<Home> {
    PageController _pageController;

    /// Indicating the current displayed page
    /// 0: Recipes
    /// 1: Plan
    /// 2: Shopping list
    int _page = 0;


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: PageView(
              children: [
                  Container(
                      child: SafeArea(
                          child: RecipesPage()
                      ),
                  ),
                  Container(
                      child: SafeArea(
                          child: PlanPage()
                      ),
                  ),
                  Container(
                      child: SafeArea(
                          child: ShoppingListPage()
                      ),
                  ),
                  Container(
                      child: SafeArea(
                          child: ExplorePage()
                      ),
                  ),
              ],

              /// Specify the page controller
              controller: _pageController,
              onPageChanged: onPageChanged
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      title: Text('Recipes')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.event),
                      title: Text('Plan')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      title: Text('Shopping List')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.public),
                      title: Text("Explore"),
                  ),
              ],
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


