import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

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
      child: Container(
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
                        borderRadius: BorderRadius.circular(Styles.cardRadius),
                        child: Image.network(cart.product.pictures[0]))),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
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
//                  Container(
//                    height: 36,
//                    width: 36,
//                    child: RaisedButton(
//                        onPressed: () {},
//                        color: Styles.colors.background,
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(18.0),
//                            side: BorderSide(color: Styles.colors.border)),
//                        child: Text(
//                          "1",
//                          style: TextStyle(
//                            fontSize: 12.0,
//                            fontWeight: FontWeight.w700,
//                            color: Styles.colors.main,
//                          ),
//                          textAlign: TextAlign.center,
//                        )),
//                  ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
