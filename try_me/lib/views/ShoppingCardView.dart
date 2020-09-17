import 'package:flutter/material.dart';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:tryme/Request.dart';

import 'package:tryme/widgets/ProductShoppingCartCard.dart';
import 'package:tryme/Globals.dart';

class ShoppingCardView extends StatefulWidget {
  @override
  _ShoppingCardViewState createState() => _ShoppingCardViewState();
}

class _ShoppingCardViewState extends State<ShoppingCardView> {
  double total = 0.0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void callback() {
    if (this.mounted)
      setState(() {
        computeTotal();
      });
  }

  void computeTotal() {
    total = 0.0;
    shoppingCard.forEach((element) {
      total += element.product.pricePerMonth;
    });
  }

  void setError(dynamic error) {
    print(error.toString());
  }

  void checkout() async {
    Map result;
    PaymentMethod _paymentMethod;
    PaymentIntentResult _paymentIntent;

    //Place order
    result =
        await Request.order('eur', 'Rennes', 'France', '30 rue Oui', 35000);

    //Init stripe
    StripePayment.setOptions(StripeOptions(
        publishableKey: result['publishableKey'],
        merchantId: "merchantIdTest",
        androidPayMode: 'androidPayModeTest'));

    //Save card token
    await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Received ${paymentMethod.id}')));
      _paymentMethod = paymentMethod;
    }).catchError(setError);

    //Confirm payment stripe
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: result['clientSecret'],
        paymentMethodId: _paymentMethod.id,
      ),
    ).then((paymentIntent) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
      _paymentIntent = paymentIntent;
    }).catchError(setError);

    //Pay order
    await Request.payOrder(result['order_id']);
  }

  @override
  void initState() {
    super.initState();
    computeTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mon Panier'),
        centerTitle: true,
        backgroundColor: Color(0xff1F2C47),
      ),
      body: (() {
        if (shoppingCard.isNotEmpty)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 9,
                child: ListView(
                  children: shoppingCard
                      .map((cart) => ProductShoppingCartCard(
                          cart: cart, callback: callback))
                      .toList(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total: $total€',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        color: Color(0xff58c24c),
                        onPressed: () {
                          checkout();
                        },
                        child: Text('Commander',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        else
          return Center(
            child: Text(
              'Votre panier est vide',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          );
      }()),
    );
  }
}
