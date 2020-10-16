import 'dart:async';

import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int _seconds = 3;

  void viewTimeout() {
    Navigator.pushNamed(context, 'home');
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: this._seconds), viewTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Landing View '),
      ),
    );
  }
}
