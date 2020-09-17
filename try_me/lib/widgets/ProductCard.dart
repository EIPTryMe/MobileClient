import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.product});

  final Product product;
  final double borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: (Container(
              height: 160,
              color: Colors.grey[100],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[300],
                      child: product.pictures == null
                          ? null
                          : Image.network(
                              product.pictures[0],
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
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                product.name == null ? '' : product.name,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                product.pricePerMonth == null
                                    ? ''
                                    : product.pricePerMonth.toString() +
                                        '€/Mois',
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
            )),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
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
