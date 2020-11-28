import 'dart:async';

import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int _seconds = 3;

  void viewTimeout() {
    Navigator.popAndPushNamed(context, 'app');
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: this._seconds), viewTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage("assets/landingView.jpg"),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
