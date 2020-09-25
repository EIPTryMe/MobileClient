import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/tools/DecodeLinkBytes.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

class ProductCard extends StatefulWidget {
  ProductCard({this.product});

  final Product product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double borderRadius = 12.0;

  //Uint8List bytes;

  @override
  void initState() {
    super.initState();

    /*if (widget.product.pictures != null &&
        widget.product.pictures[0].isNotEmpty)
      DecodeLink.decodeLinkBytes(widget.product.pictures[0]).then((value) {
        if (this.mounted)
          setState(() {
            bytes = value;
          });
      });*/
  }

  @override
  Widget build(BuildContext context) {
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
                    child: widget.product.pictures == null ||
                            widget.product.pictures[0].isEmpty
                        ? null
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.network(
                              widget.product.pictures[0],
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
                          child: Row(
                            children: [
                              Text(
                                widget.product.pricePerMonth == null
                                    ? ''
                                    : '€ ' +
                                        NumberFormatTool.formatPrice(
                                            widget.product.pricePerMonth),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(' / mois'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          //color: Colors.red,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    NumberFormatTool.formatRating(widget.product
                                                .reviews.averageRating) ==
                                            null
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 15.0,
                                                  color: Colors.red[400],
                                                ),
                                                Text(
                                                  ' ' +
                                                      NumberFormatTool
                                                          .formatRating(widget
                                                              .product
                                                              .reviews
                                                              .averageRating),
                                                  style: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.product.stock > 0
                                            ? 'Disponible '
                                            : 'Indisponible ',
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                      Icon(
                                        Icons.brightness_1,
                                        size: 15,
                                        color: widget.product.stock > 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
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
