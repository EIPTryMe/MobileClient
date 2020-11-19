import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:tryme/Auth0API.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
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

class _SignUpPasswordViewState extends State<SignUpPasswordView> {
  bool _obscureText = true;
  bool _obscureText2 = true;

  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPassword2 = GlobalKey<FormState>();

  String _password;
  String _confirmPassword;

  String _error = '';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.instance.userInteractions = false;
  }

  void showLoading() async {
    EasyLoading.show(
      status: 'Chargement...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  void connection() {
    showLoading();
    Request.getUser().whenComplete(() {
      if (user.companyId == null) {
        Request.getShoppingCard().then((cards) {
          shoppingCard = cards;
          isLoggedIn = true;
          Navigator.pushNamedAndRemoveUntil(
              context, 'app', ModalRoute.withName('/'));
        });
      } else {
        setState(() {
          _error = 'Connectez-vous en tant qu\'entreprise';
        });
      }
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
                bool passwordIsValid = RegExp(
                        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,20})")
                    .hasMatch(value);
                if (value.isEmpty) {
                  return "Vous n\'avez pas rentré votre mot de passe";
                } else if (!passwordIsValid) {
                  return "Le format de votre mot de passe est incorrect";
                }
                _password = value;
                return null;
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget _confirmPasswordRow() {
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
            key: _formKeyPassword2,
            child: TextFormField(
              obscureText: _obscureText2,
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
                  hintText: "Confirmer mot de passe",
                  hintStyle: TextStyle(
                    color: Styles.colors.title,
                    fontSize: 13.0,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _toggle2();
                    },
                    child: Icon(
                      _obscureText2
                          ? Icons.visibility_sharp
                          : Icons.visibility_off_sharp,
                      color: Styles.colors.title,
                    ),
                  )),
              validator: (value) {
                _confirmPassword = value;
                if (value.isEmpty) {
                  return "Vous n\'avez pas confirmé votre mot de passe";
                } else if (_password != _confirmPassword) {
                  return "Vos mots de passe ne correspondent pas";
                }
                return null;
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      height: 58.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKeyPassword.currentState.validate() &&
              _formKeyPassword2.currentState.validate()) {
            Auth0API.register(widget.email, _password).then((isConnected) {
              if (isConnected) {
                connection();
              }
            });
          }
        },
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

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Styles.colors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderAuthentication(content: "Entrez votre mot de passe !"),
                _passwordRow(),
                _confirmPasswordRow(),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    children: [
                      backButton(context),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: _submitButton(),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
