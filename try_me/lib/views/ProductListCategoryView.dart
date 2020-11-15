import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';
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
  bool _loading = true;
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    Request.getProducts(widget.category).then((products) {
      setState(() {
        _products = products;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Styles.mainHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GoBackTopBar(title: widget.category),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(),
                    if (_products.isNotEmpty) ProductList(products: _products),
                    Loading(active: _loading),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
