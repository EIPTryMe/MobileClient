import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/AccountRow.dart';
import 'package:tryme/widgets/HeaderAuthentication.dart';

class SignUpEmailView extends StatefulWidget {
  @override
  _SignUpEmailViewState createState() => _SignUpEmailViewState();
}

Widget backButton(BuildContext context) {
  return Container(
    height: 58.0,
    width: 58.0,
    child: RaisedButton(
      onPressed: () => Navigator.pushNamed(context, 'signIn'),
      textColor: Styles.colors.text,
      color: Styles.colors.mainAlpha50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back),
        ],
      ),
    ),
  );
}

Widget nextButton(BuildContext context) {
  return Container(
    height: 58.0,
    child: RaisedButton(
      onPressed: () => Navigator.pushNamed(context, 'signUpPassword'),
      textColor: Styles.colors.text,
      color: Styles.colors.main,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Suivant"),
          Icon(Icons.arrow_forward),
        ],
      ),
    ),
  );
}

class _SignUpEmailViewState extends State<SignUpEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAuthentication(content: "Entrez votre email !"),
              AccountRow(),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Row(
                  children: [
                    backButton(context),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: nextButton(context),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
