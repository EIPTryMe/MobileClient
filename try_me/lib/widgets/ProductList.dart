import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/ProductCard.dart';

class ProductList extends StatefulWidget {
  ProductList({this.products});

  final List<Product> products;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> _products = List();

  @override
  void initState() {
    super.initState();
    _products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    const double crossAxisSpacing = 16.0;

    return Expanded(
      child: AnimationLimiter(
        child: GridView.count(
          padding: const EdgeInsets.only(
              left: Styles.mainHorizontalPadding,
              right: Styles.mainHorizontalPadding,
              bottom: crossAxisSpacing),
          crossAxisCount: 2,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.65,
          children: List.generate(
              _products.length,
              (index) => AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: _products.length,
                    child: ScaleAnimation(
                        child: ProductCard(product: _products[index])),
                  )),
          /*children: widget.products
              .map((product) => AnimationConfiguration.staggeredGrid(
                  columnCount: 3,
                  child: ScaleAnimation(child: ProductCard(product: product))))
              .toList(),*/
        ),
      ),
    );
  }
}
