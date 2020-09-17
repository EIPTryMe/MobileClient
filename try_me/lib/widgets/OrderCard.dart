import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/widgets/ProductCard.dart';

class OrderCard extends StatelessWidget {
  OrderCard({this.order});

  final double borderRadius = 12.0;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: (Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Commande n° ',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Statut',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    (order.status == 'paid')
                        ? Text(
                            "Payée",
                            style: TextStyle(color: Colors.green[400]),
                          )
                        : (order.status == 'waiting for payment')
                            ? Text(
                                "Non payée",
                                style: TextStyle(color: Colors.orange[400]),
                              )
                            : Text(''),
                  ],
                ),
                Column(
                    children: order.products
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ProductCard(product: e),
                            ))
                        .toList()),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Divider(
                    height: 50,
                    color: Colors.grey[800],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nombres d\'articles',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(order.products.length.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prix total',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order.total.toString() + '€',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
