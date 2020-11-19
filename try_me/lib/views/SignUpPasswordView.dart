import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/HeaderAuthentication.dart';

class SignUpPasswordView extends StatefulWidget {
  SignUpPasswordView({this.email});

  final String email;

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
  bool _obscureText = true;
  final _formKeyPassword = GlobalKey<FormState>();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _passwordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: Styles.colors.iconLock,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Form(
                key: _formKeyPassword,
                child: TextFormField(
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Styles.colors.title,
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Styles.colors.title, width: 1.0)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Styles.colors.title, width: 1.0)),
                      hintText: "Mot de passe",
                      hintStyle: TextStyle(
                        color: Styles.colors.title,
                        fontSize: 13.0,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _toggle();
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_sharp
                              : Icons.visibility_off_sharp,
                          color: Styles.colors.title,
                        ),
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Vous n'avez pas rentré votre mot de passe";
                    }
                   // _password = value;
                    return null;
                  },
                ),
              ),
            )),
      ],
    );
  }

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
           //   PasswordRow(content: "Mot de passe"),
            //  PasswordRow(content: "Confirmer mot de passe"),
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
