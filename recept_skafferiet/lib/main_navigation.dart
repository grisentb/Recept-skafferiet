import 'package:flutter/material.dart';
import 'package:recept_skafferiet/screens/add_recipe/add_recipe.dart';
import 'package:recept_skafferiet/screens/cookbook/cookbook.dart';
import 'package:recept_skafferiet/screens/home/home.dart';
import 'package:recept_skafferiet/screens/account.dart';

/// This is the main application widget.
class Nav extends StatelessWidget {
  static const route = "/Nav";
  final session;


  Nav(this.session);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavStateful(this.session),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class NavStateful extends StatefulWidget {
  final session;
  NavStateful(this.session);
  @override
  State<NavStateful> createState() => _NavState(session: this.session);
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavState extends State<NavStateful> {
  var session;
  var _mainScreens;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  _NavState({this.session}){
    print("INSIDE NAV -> " + this.session.toString());
    _mainScreens = new List<Widget>.from([
      new Home(this.session), 
      new NewRecipe(this.session), 
      new CookBook(this.session), 
      new Account(this.session),
      ]);
  }
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _mainScreens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Recept',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add_outlined),
            label: 'Nytt recept',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Kokbok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Konto',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class NavArguments {
  final dynamic session;

  NavArguments(this.session);
}
