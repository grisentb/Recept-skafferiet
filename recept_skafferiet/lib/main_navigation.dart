import 'package:flutter/material.dart';
import 'package:recept_skafferiet_app/screens/home/home.dart';
import 'package:recept_skafferiet_app/screens/recipe/recipe_screen.dart';

/// This is the main application widget.
class Nav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavStateful(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class NavStateful extends StatefulWidget {
  const NavStateful({Key key}) : super(key: key);

  @override
  State<NavStateful> createState() => _NavState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavState extends State<NavStateful> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _mainScreens = <Widget>[
    Home(),
    Text(
      'Lägg till nytt recept',
      style: optionStyle,
    ),
    Text(
      'Min kokbok',
      style: optionStyle,
    ),
    Text(
      'Mitt konto',
      style: optionStyle,
    ),
  ];

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
        items: const <BottomNavigationBarItem>[
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
            label: 'Min kokbok',
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
