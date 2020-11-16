import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

class ProductCard extends StatefulWidget {
  ProductCard({this.product});

  final Product product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Product _product = Product();

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _product.pictures.isNotEmpty
                        ? Image(
                            image: NetworkImage(_product.pictures[0]),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Styles.colors.title, fontSize: 11),
                  ),
                  Text(
                    NumberFormatTool.formatPrice(_product.pricePerMonth) +
                        '€ / mois',
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(Styles.cardRadius),
              onTap: () =>
                  Navigator.pushNamed(context, 'product/${_product.id}'),
            ),
          ),
        ),
      ],
    );
  }
}
