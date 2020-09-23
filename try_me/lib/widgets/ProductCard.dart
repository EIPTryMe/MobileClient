import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/tools/DecodeLinkBytes.dart';

class ProductCard extends StatefulWidget {
  ProductCard({this.product});

  final Product product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double borderRadius = 12.0;
  Uint8List bytes;

  @override
  void initState() {
    super.initState();
    if (widget.product.pictures != null &&
        widget.product.pictures[0].isNotEmpty)
      decodeLinkBytes(widget.product.pictures[0]).then((value) {
        setState(() {
          bytes = value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatDecimal = NumberFormat("###.00#", "fr");
    NumberFormat formatInteger = NumberFormat("###.#", "fr");
    String formattedPrice = '';

    if (widget.product.pricePerMonth.toInt() != widget.product.pricePerMonth)
      formattedPrice = formatDecimal.format(widget.product.pricePerMonth);
    else
      formattedPrice = formatInteger.format(widget.product.pricePerMonth);

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
                    child: bytes == null
                        ? null
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.memory(
                              bytes,
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
                              widget.product.name == null
                                  ? ''
                                  : widget.product.name,
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
                            widget.product.brand == null
                                ? ''
                                : widget.product.brand,
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
                                  widget.product.pricePerMonth == null
                                      ? ''
                                      : '€ ' + formattedPrice,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white10,
                onTap: () => Navigator.pushNamed(
                    context, 'product/${widget.product.id}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
