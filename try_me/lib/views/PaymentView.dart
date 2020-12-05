import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';

import 'package:tryme/tools/AddressTool.dart';

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';

  bool _isCvvFocused = false;
  bool _checkAddress = false;

  PaymentMethod _paymentMethod;

  String _street = "";
  String _postCode = "";
  String _city = "";
  String _country = "";

  @override
  void initState() {
    _street = user.address.street != null ? user.address.street : "";
    _postCode = user.address.postCode != null ? user.address.postCode : "";
    _city = user.address.city != null ? user.address.city : "";
    _country = user.address.country != null ? user.address.country : "";
    super.initState();
  }

  void addCreditCard() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_qqOqbG3XvLbLfopJ2yWEmrKK00FqSnGPaA",
        merchantId: "Test",
        androidPayMode: 'test'));

    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      setState(() {
        _paymentMethod = paymentMethod;
        _cardNumber = "0000 0000 0000 ${paymentMethod.card.last4}";
        _expiryDate =
            "${paymentMethod.card.expMonth}/${paymentMethod.card.expYear}";
        _cardHolderName = "${user.firstName} ${user.lastName}";
        _cvvCode = "";
      });
    }).catchError(setError);
  }

  void setError(dynamic error) {
    print(error);
  }

  Future<bool> checkout() async {
    QueryResult result;

    result = await Request.order(
        'eur', _city, _country, _street, int.parse(_postCode));
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: result.data['orderPayment']['clientSecret'],
        paymentMethodId: _paymentMethod.id,
      ),
    ).catchError(setError);
    if (result.hasException) return (false);
    await Request.payOrder(result.data['orderPayment']['order_id']).then((hasException) {
      if (hasException) return (false);
    });

    return (true);
  }

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
    _checkAddress =
        (_street != "" && _postCode != "" && _city != "" && _country != "");
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
                _street,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Text(
                "$_postCode $_city",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: Text(
                  _country,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: Styles.colors.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: GestureDetector(
                  onTap: () {
                    AddressTool.getAddress(
                            context,
                            user.address.fullAddress != null
                                ? user.address.fullAddress.addressLine
                                : "")
                        .then((address) {
                      setState(() {
                        _street =
                            '${address.subThoroughfare} ${address.thoroughfare}';
                        _postCode = address.postalCode;
                        _city = address.locality;
                        _country = address.countryName;
                      });
                    }).catchError((_) {});
                  },
                  child: Text(
                    "Change",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Styles.colors.main,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Theme(
              data: Theme.of(context).copyWith(
                disabledColor:
                    _checkAddress ? Styles.colors.main : Styles.colors.text,
              ),
              child: Radio()),
        ],
      ),
    );
  }

  Widget _creditCard() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
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
                height: 200,
                width: 350,
                child: GestureDetector(
                  onTap: () => addCreditCard(),
                  child: CreditCardWidget(
                    cardNumber: _cardNumber,
                    expiryDate: _expiryDate,
                    cardHolderName: _cardHolderName,
                    cvvCode: _cvvCode,
                    showBackView: _isCvvFocused,
                  ),
                ),
              ),
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
          onPressed: (_checkAddress && _paymentMethod != null)
              ? () {
                  checkout().then((succeed) {
                    print("ok");
                  });
                }
              : null,
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Styles.mainHorizontalPadding, vertical: 10.0),
              child: GoBackTopBar(
                  title: "Votre commande",
                  titleFontSize: 20,
                  titleHeightSize: 20),
            ),
            Expanded(
              child: ListView(
                children: [
                  _orderNumber(),
                  SizedBox(height: 15),
                  _shippingAddress(),
                  SizedBox(height: 10),
                  _creditCard(),
                  SizedBox(height: 15),
                  _priceInformation(),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: _checkOutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
