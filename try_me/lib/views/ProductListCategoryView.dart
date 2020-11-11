import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductListCategoryView extends StatefulWidget {
  ProductListCategoryView({this.category});

  final String category;

  @override
  _ProductListCategoryViewState createState() =>
      _ProductListCategoryViewState();
}

class _ProductListCategoryViewState extends State<ProductListCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text('Product list: ' + widget.category)),
      ),
    );
  }
}
