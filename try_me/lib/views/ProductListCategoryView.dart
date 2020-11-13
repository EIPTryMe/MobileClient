import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/ProductList.dart';

class ProductListCategoryView extends StatefulWidget {
  ProductListCategoryView({this.category});

  final String category;

  @override
  _ProductListCategoryViewState createState() =>
      _ProductListCategoryViewState();
}

class _ProductListCategoryViewState extends State<ProductListCategoryView> {
  List<Product> _products = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Request.getProducts(widget.category).then((products) {
      setState(() {
        _products = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              GoBackTopBar(title: widget.category),
              if (_products.isNotEmpty) ProductList(products: _products),
            ],
          ),
        ),
      ),
    );
  }
}
