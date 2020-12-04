import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stripe_payment/stripe_payment.dart';

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

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      color: Styles.colors.lightBackground,
      child: Row(
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
          Radio(

          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            _orderNumber(),
            SizedBox(height: 15),
            _shippingAddress(),
          ],
        ),
      ),
    );
  }
}
