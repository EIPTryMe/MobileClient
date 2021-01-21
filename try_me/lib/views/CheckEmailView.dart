import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';

class CheckEmailView extends StatefulWidget {
  @override
  _CheckEmailViewState createState() => _CheckEmailViewState();
}

class _CheckEmailViewState extends State<CheckEmailView> {
  void setError(dynamic error) {
    print(error.toString());
  }

  Widget _check() {
    double width = MediaQuery.of(context).size.width;
    double widthNeeded = (width - 50) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthNeeded),
      child: Container(
        height: 50,
        width: 50,
        child: Center(
          child: Icon(
            Icons.email_outlined,
            size: 50.0,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _goBackHomeViewButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Styles.colors.main,
      textColor: Styles.colors.text,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Styles.buttonRadius),
      ),
      child: Text(
        "Retour",
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérification adresse mail'),
        centerTitle: true,
        backgroundColor: Styles.colors.background,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _check(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Un mail d\'activation a été envoyé à l\'adresse ${user.email}',
              style: TextStyle(
                color: Styles.colors.text,
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Styles.mainHorizontalPadding),
            child: _goBackHomeViewButton(),
          ),
        ],
      ),
      backgroundColor: Styles.colors.background,
    );
  }
}
