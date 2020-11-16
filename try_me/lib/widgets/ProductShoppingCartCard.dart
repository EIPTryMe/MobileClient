import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';

class ProductShoppingCartCard extends StatefulWidget {
  ProductShoppingCartCard({this.cart, this.callback});

  final Cart cart;
  final Function callback;

  @override
  _ProductShoppingCartCardState createState() =>
      _ProductShoppingCartCardState();
}

class _ProductShoppingCartCardState extends State<ProductShoppingCartCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 160,
          color: Colors.grey[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.grey[300],
                  child: widget.cart.product.pictures.isEmpty
                      ? null
                      : Image.network(
                          widget.cart.product.pictures[0],
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.cart.product.name != null
                                ? widget.cart.product.name
                                : '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.cart.product.pricePerMonth != null
                                ? widget.cart.product.pricePerMonth.toString() +
                                    '€/Mois'
                                : '',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white10,
              onTap: () => Navigator.pushNamed(
                  context, 'product/${widget.cart.product.id}'),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                  ),
                  color: widget.cart.quantity > 1
                      ? Colors.black
                      : Colors.grey[400],
                  onPressed: () {
                    if (widget.cart.quantity > 1) {
                      widget.cart.quantity--;
                      setState(() {});
                    }
                  },
                ),
                Text(widget.cart.quantity.toString()),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                  ),
                  onPressed: () {
                    widget.cart.quantity++;
                    setState(() {});
                  },
                ),
                SizedBox(width: 75),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    Request.deleteShoppingCard(widget.cart.product.id)
                        .then((hasException) {
                      if (!hasException) {
                        Request.getShoppingCard()
                            .whenComplete(() => widget.callback());
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
