import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/GoBackTopBar.dart';

class ShoppingCardView extends StatefulWidget {
  @override
  _ShoppingCardViewState createState() => _ShoppingCardViewState();
}

class _ShoppingCardViewState extends State<ShoppingCardView> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    Request.getShoppingCard().then((cards) {
      setState(() {
        shoppingCard = cards;
      });
    });
  }

  Widget ShoppingCardCart(BuildContext context, Cart cart) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Container(
              height: 125.0,
              width: 105,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Styles.cardRadius),
              ),
              child: cart.product.pictures.isEmpty
                  ? null
                  : Image.network(cart.product.pictures[0])),
          Expanded(
              child: Container(
            height: 125.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  cart.product.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Styles.colors.text,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "€" + cart.product.pricePerMonth.toString() + " / mois",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Styles.colors.text,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
          Container(
            height: 125.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  child: RaisedButton(
                      onPressed: () {},
                      color: Styles.colors.background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Styles.colors.border)),
                      child: Text(
                        "1",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Styles.colors.main,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                IconButton(icon: Icon(Icons.delete_forever), color: Styles.colors.unSelected, onPressed: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: [
          Expanded(flex: 1, child: GoBackTopBar(title: "Panier")),
          Expanded(
            flex: 10,
            child: ListView.builder(
              itemCount: shoppingCard.length,
              itemBuilder: (BuildContext context, int index) {
                return ShoppingCardCart(context, shoppingCard[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

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
  List<Cart> _shoppingCard = List();

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

    _shoppingCard.forEach((element) {
      total += element.product.pricePerMonth;
    });
    return (total);
  }

  void setError(dynamic error) {
    print(error.toString());
  }

  void getData() async {
    Request.getShoppingCard().then((hasException) {
      if (!hasException)
        computeTotal().then((total) {
          setState(() {
            _shoppingCard = shoppingCard;
            _total = total;
          });
        });
    });
  }

  @override
  void initState() {
    print('taracelapute');
    getData();
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
        if (_shoppingCard.isNotEmpty)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 12,
                child: ListView.builder(
                  itemCount: _shoppingCard.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductShoppingCartCard(
                        cart: _shoppingCard[index], callback: callback);
                  },
                  /*children: _shoppingCard
                      .map((cart) => ProductShoppingCartCard(
                          cart: cart, callback: callback))
                      .toList(),*/
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
}*/
