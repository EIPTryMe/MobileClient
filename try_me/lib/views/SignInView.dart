import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/AccountRow.dart';
import 'package:tryme/widgets/HeaderAuthentication.dart';
import 'package:tryme/widgets/PasswordRow.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

Widget goButton() {
  return Container(
    height: 58.0,
    child: RaisedButton(
      onPressed: () {},
      textColor: Styles.colors.text,
      color: Styles.colors.main,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Go !"),
          Icon(Icons.arrow_forward),
        ],
      ),
    ),
  );
}

Widget FacebookButton() {
  return Container(
    height: 58.0,
    child: RaisedButton(
      onPressed: () {},
      color: Styles.colors.facebookButton,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Image(image: AssetImage("assets/facebookIcon.png")),
    ),
  );
}

Widget GoogleButton() {
  return Container(
    height: 58.0,
    child: RaisedButton(
      onPressed: () {},
      color: Styles.colors.googleButton,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Image(image: AssetImage("assets/googleIcon.png")),
    ),
  );
}

Widget CreateAccountButton(BuildContext context) {
  return Container(
    height: 58.0,
    child: RaisedButton(
      onPressed: () => Navigator.pushNamed(context, 'signUpEmail'),
      textColor: Styles.colors.text,
      color: Styles.colors.mainAlpha50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Créer un compte"),
        ],
      ),
    ),
  );
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.colors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAuthentication(content: "Connectez-vous"),
            AccountRow(),
            PasswordRow(content: "Mot de passe"),
            goButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(color: Styles.colors.title, fontSize: 14.0),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            Row(
              children: [
                Expanded(flex: 1, child: FacebookButton()),
                SizedBox(width: 7.0),
                Expanded(flex: 1, child: GoogleButton()),
              ],
            ),
            CreateAccountButton(context),
          ],
        ),
      ),
    );
  }
}
