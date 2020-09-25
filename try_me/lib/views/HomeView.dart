import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';

import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/widgets/ListProducts.dart';
import 'package:tryme/widgets/Orders.dart';
import 'package:tryme/widgets/UserInformation.dart';

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
    UserInformation(),
    ShoppingCardView(appBar: false),
    Orders(),
  ];

  void _onItemTapped(int index) {
    if (!isLoggedIn && (index == 1 || index == 2 || index == 3)) {
      Navigator.pushNamed(context, "authentification");
    } else {
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
            title: Text('Accueil'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mon Compte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Panier'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Commandes'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff1F2C47),
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}
