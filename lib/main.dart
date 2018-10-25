import 'package:flutter/material.dart';
import 'package:recipe/pages/RecipesPage.dart';

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
                  Container(color: Colors.blue),
                  Container(color: Colors.grey)
              ],

              /// Specify the page controller
              controller: _pageController,
              onPageChanged: onPageChanged
          ),
          bottomNavigationBar: BottomNavigationBar(
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
                  )
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
        _pageController = PageController();
    }

    @override
    void dispose(){
        super.dispose();
        _pageController.dispose();
    }
}


