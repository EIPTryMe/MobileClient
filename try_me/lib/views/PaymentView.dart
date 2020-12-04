import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  Widget _divider({height: 2.0}) {
    return Divider(
      height: height,
      color: Styles.colors.divider,
    );
  }

  Widget _orderNumber() {
    const double imageBoxSize = 90.0;
    return Column(children: [
      _divider(),
      Container(
        height: imageBoxSize,
        color: Styles.colors.lightBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: imageBoxSize,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(
                  padding: const EdgeInsets.all(imageBoxSize * 0.3 / 2.0),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(user.picture != null ? user.picture : ""),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Récapitulatif de votre commande",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      _divider(),
    ]);
  }

  Widget _shippingAddress() {
    String street = user.address.street != null ? user.address.street : "";
    String postCode =
        user.address.postCode != null ? user.address.postCode : "";
    String city = user.address.city != null ? user.address.city : "";
    String country = user.address.country != null ? user.address.country : "";

    bool checkAddress =
        (street != "" && postCode != "" && city != "" && country != "");
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      color: Styles.colors.lightBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Text(
                  "Adresse de livraison",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22.0,
                    color: Styles.colors.text,
                  ),
                ),
              ),
              Text(
                street,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Text(
                "$postCode $city",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: Text(
                  country,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: Styles.colors.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  "Change",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    color: Styles.colors.main,
                  ),
                ),
              ),
            ],
          ),
          Theme(
              data: Theme.of(context).copyWith(
                disabledColor:
                    checkAddress ? Styles.colors.main : Styles.colors.text,
              ),
              child: Radio()),
        ],
      ),
    );
  }



  Widget _creditCard() {
    String cardNumber = '';
    String expiryDate = '';
    String cardHolderName = '';
    String cvvCode = '';
    bool isCvvFocused = false;

    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paiement",
                style: TextStyle(
                  color: Styles.colors.text,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 180,
                width: 300,
                child: CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceInformation() {
    String price = "28.00";
    String shippingPrice = "7.20";
    String total = "35.20";

    return Container(
      color: Styles.colors.lightBackground,
      padding: const EdgeInsets.symmetric(
          horizontal: Styles.mainHorizontalPadding, vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Commande",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Livraison",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Total",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$price €",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$shippingPrice €",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$total €",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkOutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
      child: Container(
        height: 58.0,
        width: 315.0,
        child: RaisedButton(
          onPressed: () {},
          textColor: Styles.colors.text,
          color: Styles.colors.main,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            "Payer",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Styles.colors.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            _orderNumber(),
            SizedBox(height: 15),
            _shippingAddress(),
            SizedBox(height: 10),
            Expanded(child: _creditCard()),
            SizedBox(height: 15),
            _priceInformation(),
            SizedBox(height: 15),
            _checkOutButton(),
          ],
        ),
      ),
    );
  }
}
