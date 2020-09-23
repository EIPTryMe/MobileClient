import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:tryme/Globals.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.product});

  final Product product;
  final double borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    NumberFormat formatDecimal = NumberFormat("###.00#", "fr");
    NumberFormat formatInteger = NumberFormat("###.#", "fr");
    String formattedPrice = '';

    if (product.pricePerMonth.toInt() != product.pricePerMonth)
      formattedPrice = formatDecimal.format(product.pricePerMonth);
    else
      formattedPrice = formatInteger.format(product.pricePerMonth);
    return Stack(
      children: <Widget>[
        Container(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: product.pictures == null
                        ? null
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.network(
                              product.pictures[0],
                              fit: BoxFit.cover,
                            ),
                          ),
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
                        flex: 2,
                        child: Container(
                          //color: Colors.blue,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              product.name == null ? '' : product.name,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          //color: Colors.yellow,
                          child: Text(
                            product.brand == null ? '' : product.brand,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          //: Colors.green,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  product.pricePerMonth == null
                                      ? ''
                                      : '€ ' + formattedPrice,
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                Text(' / mois'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                            //color: Colors.red,
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
          child: ClipRRect(
            //borderRadius: BorderRadius.circular(borderRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white10,
                onTap: () =>
                    Navigator.pushNamed(context, 'product/${product.id}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
