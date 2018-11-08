import 'package:MealEngineer/pages/ExplorePage.dart';
import 'package:MealEngineer/pages/PlanPage.dart';
import 'package:MealEngineer/pages/ShoppingListPage.dart';
import 'package:flutter/material.dart';
import 'package:MealEngineer/pages/RecipesPage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: '',
            home: Home()
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
                      icon: Icon(Icons.calendar_today),
                      title: Text('Plan')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      title: Text('Shopping List')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text("works"),
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


