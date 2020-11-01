import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/views/HomeView.dart';
import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/views/UserInformationView.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List _widgets = [
    ShoppingCardView(),
    HomeView(),
    UserInformationView(),
  ];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    double _radius = 25;

    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: _widgets[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
          boxShadow: [
            BoxShadow(
              color: Styles.colors.background,
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
          child: SizedBox(
            height: 95,
            child: BottomNavigationBar(
              backgroundColor: Styles.colors.lightBackground,
              selectedItemColor: Styles.colors.main,
              unselectedItemColor: Styles.colors.unSelected,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  label: 'Panier',
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Acceuil',
                  icon: Icon(
                    Icons.home_filled,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Compte',
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  if (isLoggedIn == false && (index == 0 || index == 2))
                    Navigator.pushNamed(context, 'authentification');
                  else
                    _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
