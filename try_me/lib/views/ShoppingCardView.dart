import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

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

  Widget _orderButton() {
    return Container(
      height: 58.0,
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
    );
  }

  Widget _shoppingCardCart(Cart cart) {
    String price = NumberFormatTool.formatPrice(cart.product.pricePerMonth);

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
                    child: cart.product.pictures.isEmpty
                        ? null
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Styles.cardRadius),
                            child: Image.network(cart.product.pictures[0]))),
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
                    ],
                  ),
                )),
                Container(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Styles.colors.unSelected,
                        onPressed: () {
                          Request.deleteShoppingCard(cart.product.id)
                              .then((hasException) {
                            if (!hasException) {
                              getData();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 40.0),
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
    if (shoppingCard.length != 0)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  right: Styles.mainHorizontalPadding,
                  left: Styles.mainHorizontalPadding,
                  top: 15.0),
              itemCount: shoppingCard.length,
              itemBuilder: (BuildContext context, int index) {
                return _shoppingCardCart(shoppingCard[index]);
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
      );
    else
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Votre panier est vide",
              style: TextStyle(color: Styles.colors.text, fontSize: 30.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Icon(Icons.shopping_cart_rounded, color: Styles.colors.text,size: 50),
            ),
          ],
        ),
      );
  }
}
