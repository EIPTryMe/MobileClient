import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home View',
        style: TextStyle(color: Styles.colors.text),
      ),
    );
  }
}
