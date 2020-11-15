import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/HeaderAuthentication.dart';
import 'package:tryme/widgets/PasswordRow.dart';

class SignUpPasswordView extends StatefulWidget {
  @override
  _SignUpPasswordViewState createState() => _SignUpPasswordViewState();
}

Widget backButton(BuildContext context) {
  return Container(
    height: 58.0,
    width: 58.0,
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
          Icon(Icons.arrow_back),
        ],
      ),
    ),
  );
}

Widget confirmButton(BuildContext context) {
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
          Text("Valider"),
        ],
      ),
    ),
  );
}

class _SignUpPasswordViewState extends State<SignUpPasswordView> {
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
              HeaderAuthentication(content: "Entrez votre mot de passe !"),
              PasswordRow(content: "Mot de passe"),
              PasswordRow(content: "Confirmer mot de passe"),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  children: [
                    backButton(context),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: confirmButton(context),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
