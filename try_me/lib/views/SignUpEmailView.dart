import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

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
                  return "Vous n'avez pas rentré votre email";
                }
                _email = value;
                return null;
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

  Widget _submitButton() {
    return ButtonTheme(
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKeyEmail.currentState.validate() &&
              _formKeyPassword.currentState.validate() &&
              _formKeyConfirmPassword.currentState.validate()) {
            Auth0API.register(_email, _password).then((isConnected) {
              if (isConnected) {
                connection();
              }
            });
          }
        },
        color: Color(0xffFCA311),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          "S'inscrire",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        padding: const EdgeInsets.all(0.0),
      ),
    );
  }

  Widget _iDPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldEmail("Email"),
        SizedBox(height: 20.0),
        _entryFieldPassword("Mot de Passe"),
        SizedBox(height: 20.0),
        _entryFieldConfirmPassword("Confirmer Mot de Passe"),
      ],
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      child: FacebookSignInButton(
        text: "Se connecter avec Facebook",
        onPressed: () {
          Auth0API.webAuth(SocialAuth_e.FACEBOOK).then((isConnected) {
            if (isConnected) {
              connection();
            }
          });
        },
      ),
    );
  }

  Widget _googleButton() {
    return Container(
      height: 50,
      child: GoogleSignInButton(
        text: "Se connecter avec Google",
        onPressed: () {
          Auth0API.webAuth(SocialAuth_e.GOOGLE).then((isConnected) {
            if (isConnected) {
              connection();
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FlutterEasyLoading(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _iDPasswordWidget(),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      _submitButton(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _facebookButton(),
                      Divider(),
                      _googleButton(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
