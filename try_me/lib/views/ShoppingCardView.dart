import 'package:flutter/material.dart';

import 'package:tryme/widgets/ProductShoppingCartCard.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';

class ShoppingCardView extends StatefulWidget {
  final bool appBar;

  ShoppingCardView({this.appBar = true});

  @override
  _ShoppingCardViewState createState() => _ShoppingCardViewState();
}

class _ShoppingCardViewState extends State<ShoppingCardView> {
  double _total = 0.0;

  void callback() {
    computeTotal().then((value) {
      if (this.mounted)
        setState(() {
          _total = value;
        });
    });
  }

  Future computeTotal() async {
    double total = 0.0;

    shoppingCard.forEach((element) {
      total += element.product.pricePerMonth;
    });
    return (total);
  }

  void setError(dynamic error) {
    print(error.toString());
  }

  @override
  void initState() {
    Request.getShoppingCard().then((hasException) {
      if (!hasException)
        computeTotal().then((total) {
          setState(() {
            _total = total;
          });
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.appBar
          ? null
          : AppBar(
              title: Text('Panier'),
              centerTitle: true,
              backgroundColor: Color(0xff1F2C47),
            ),
      body: (() {
        if (shoppingCard.isNotEmpty)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 12,
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
                          child: Text('Total: $_total€',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        color: Color(0xff58c24c),
                        onPressed: () => Navigator.pushNamed(
                            context, "orderDeliveryOptions"),
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
