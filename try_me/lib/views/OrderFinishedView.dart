import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';

class OrderFinishedView extends StatefulWidget {
  OrderFinishedView({this.orderId});

  final String orderId;

  @override
  _OrderFinishedViewState createState() => _OrderFinishedViewState();
}

class _OrderFinishedViewState extends State<OrderFinishedView> {
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
            Icons.check,
            size: 50.0,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _acknowledgements() {
    String name = user.firstName;
    return Text(
      "Merci $name !",
      style: TextStyle(
        color: Styles.colors.text,
        fontSize: 25,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.center,
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
        "Ok",
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _emailConfirmationOrder() {
    String email = user.email;

    return Text(
      "Un email récapitulatif a été envoyé à $email.\nDes questions ?"
      "\n Contactez nous à tryme_2021@labeip.epitech.eu",
      style: TextStyle(
        color: Styles.colors.text,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation de la commande'),
        centerTitle: true,
        backgroundColor: Styles.colors.background,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _check(),
          _acknowledgements(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Votre commande numéro ${widget.orderId} a bien été prise en compte.',
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
          _emailConfirmationOrder(),
        ],
      ),
      backgroundColor: Styles.colors.background,
    );
  }
}
