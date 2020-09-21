import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';

import 'package:tryme/widgets/ListProducts.dart';
import 'package:tryme/widgets/UserInformations.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ListProducts(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
  UserInformations(),
  ];

  void _onItemTapped(int index) {
    if (!isLoggedIn && (index == 1 || index == 2) ) {
      Navigator.pushNamed(context, "authentification");
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Panier'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mon Compte'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}
