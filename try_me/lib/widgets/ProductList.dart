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
  @override
  Widget build(BuildContext context) {
    const double crossAxisSpacing = 16.0;

    return AnimationLimiter(
      child: GridView.builder(
          padding: const EdgeInsets.only(
              left: Styles.mainHorizontalPadding,
              right: Styles.mainHorizontalPadding,
              bottom: crossAxisSpacing),
          itemCount: widget.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: widget.products.length,
              child: ScaleAnimation(
                child: ProductCard(product: widget.products[index]),
              ),
            );
          }),
    );
  }
}
