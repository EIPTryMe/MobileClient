import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/HeaderAuthentication.dart';

import 'package:tryme/tools/Validator.dart';

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

class _SignUpEmailViewState extends State<SignUpEmailView> {
  final _formKeyEmail = GlobalKey<FormState>();
  var _email;
  String error = '';

  Widget _accountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Styles.colors.iconAccount,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Form(
            key: _formKeyEmail,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
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
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Styles.colors.title,
                    fontSize: 13.0,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vous n\'avez pas rentré votre email";
                }
                _email = value;
                return Validator.emailValidator(value);
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget nextButton() {
    return Container(
      height: 58.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKeyEmail.currentState.validate())
            Navigator.pushNamed(context, 'signUpPassword/$_email');
        },
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
              _accountRow(),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Row(
                  children: [
                    backButton(context),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: nextButton(),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

/*
* import 'package:flutter/material.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:tryme/Auth0API.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyConfirmPassword = GlobalKey<FormState>();
  var _email;
  var _password;
  var _confirmPassword;
  String error = '';

  @override
  void initState() {
    super.initState();
    EasyLoading.instance.userInteractions = false;
  }

  void showLoading() {
    EasyLoading.show(
      status: 'Chargement...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  void connection() {
    showLoading();
    Request.getUser().whenComplete(() {
      isLoggedIn = true;
      Navigator.pushNamedAndRemoveUntil(
          context, 'app/2', ModalRoute.withName('/'));
    });
  }



  Widget _entryFieldPassword(String title) {
    return Container(
      child: Form(
        key: _formKeyPassword,
        child: TextFormField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff1f2c76), width: 2.0)),
            labelText: title,
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
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
    );
  }

  Widget _entryFieldConfirmPassword(String title) {
    return Container(
      child: Form(
        key: _formKeyConfirmPassword,
        child: TextFormField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff1f2c76), width: 2.0)),
            labelText: title,
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
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
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Déjà inscrit ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'signIn');
            },
            child: Text(
              'Connectez-vous',
              style: TextStyle(
                  color: Color(0xffFCA311),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

*/
