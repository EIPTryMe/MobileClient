import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/Loading.dart';

class ShoppingCardView extends StatefulWidget {
  @override
  _ShoppingCardViewState createState() => _ShoppingCardViewState();
}

class _ShoppingCardViewState extends State<ShoppingCardView> {
  bool _loading = true;
  bool _lock = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    Request.getShoppingCard().whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  void getTotal() {
    shoppingCard.total = 0.0;
    shoppingCard.shoppingCard.forEach((cart) {
      shoppingCard.total += cart.product.pricePerMonth * cart.quantity;
    });
  }

  void updateQuantity(Cart cart, int quantity) async {
    if (quantity < 1) return;
    setState(() {
      _loading = true;
      _lock = true;
    });
    Request.modifyQuantity(cart, quantity).then((hasException) {
      if (!hasException)
        getData();
      else
        setState(() {
          _loading = false;
          _lock = false;
        });
    });
  }

  void _showDialog(int cartId, int duration) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            initialIntegerValue: duration,
            minValue: 1,
            maxValue: 10,
            title: Text("Durée de la location (mois)"),
          );
        }).then((value) {
      if (value != null) {
        setState(() {
          _loading = true;
        });
        Request.modifyCartDuration(cartId, value).whenComplete(() {
          Request.getShoppingCard().whenComplete(() {
            setState(() {
              _loading = false;
            });
          });
        });
      }
    });
  }

  Widget _orderButton() {
    return Container(
      height: 58.0,
      child: RaisedButton(
        onPressed: () => Navigator.pushNamed(context, "payment"),
        textColor: Styles.colors.text,
        color: Styles.colors.main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          "Payer (${NumberFormatTool.formatPrice(shoppingCard.total)}€ / mois)",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _shoppingCardCart(Cart cart) {
    String price = NumberFormatTool.formatPrice(cart.product.pricePerMonth);
    String duration = cart.duration.toString();

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Stack(
        children: [
          Container(
            height: 125.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 105,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                    child: cart.product.pictures.isNotEmpty
                        ? Image.network(cart.product.pictures[0])
                        : null,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 20.0, bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          cart.product.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Styles.colors.text,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$price€ / mois",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Styles.colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "$duration mois",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Styles.colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: IconButton(
                            onPressed: cart.quantity == 1
                                ? null
                                : () {
                                    updateQuantity(cart, cart.quantity - 1);
                                  },
                            icon: Icon(
                              Icons.remove,
                              color: cart.quantity == 1
                                  ? Styles.colors.unSelected
                                  : Styles.colors.text,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: Styles.colors.main,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.5)),
                          ),
                          child: Center(
                            child: Text(
                              'x${cart.quantity.toString()}',
                              style: TextStyle(
                                color: Styles.colors.text,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: cart.quantity == cart.product.stock
                                ? null
                                : () {
                                    updateQuantity(cart, cart.quantity + 1);
                                  },
                            icon: Icon(
                              Icons.add,
                              color: cart.quantity == cart.product.stock
                                  ? Styles.colors.unSelected
                                  : Styles.colors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _showDialog(cart.id, cart.duration);
                            });
                          },
                          child: Text(
                            '${cart.duration} mois',
                            style: TextStyle(color: Styles.colors.text),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Styles.colors.unSelected,
                          onPressed: () {
                            setState(() => _loading = true);
                            Request.deleteShoppingCard(cart.id)
                                .then((hasException) {
                              getData();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 140.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                  onTap: () => Navigator.pushNamed(
                      context, 'product/${cart.product.id}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (shoppingCard.shoppingCard.length != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      right: Styles.mainHorizontalPadding,
                      left: Styles.mainHorizontalPadding,
                      top: 15.0),
                  itemCount: shoppingCard.shoppingCard.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _shoppingCardCart(shoppingCard.shoppingCard[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0,
                    right: Styles.mainHorizontalPadding,
                    left: Styles.mainHorizontalPadding,
                    bottom: 10.0),
                child: _orderButton(),
              ),
            ],
          )
        else
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Votre panier est vide",
                  style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.shopping_cart_rounded,
                      color: Styles.colors.text, size: 50),
                ),
              ],
            ),
          ),
        Loading(active: _loading),
      ],
    );
  }
}
