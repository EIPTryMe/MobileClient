import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/Loading.dart';
import 'package:tryme/widgets/ProductList.dart';
import 'package:tryme/widgets/SearchBar.dart';

class SearchResultView extends StatefulWidget {
  SearchResultView({Key key, this.keywords}) : super(key: key);

  final String keywords;

  @override
  _SearchResultViewState createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  List<Product> _products = List();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getData(widget.keywords);
  }

  void getData(String keywords) async {
    setState(() {
      _products = List();
      _loading = true;
    });
    Request.getProductsSearch(keywords).then((products) {
      setState(() {
        _products = products;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();

    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: Styles.mainHorizontalPadding,
                  right: Styles.mainHorizontalPadding,
                  bottom: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SearchBar(
                      text: widget.keywords,
                      onSubmitted: (keywords) {
                        getData(keywords);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  KeyedSubtree(
                      key: key, child: ProductList(products: _products)),
                  Loading(active: _loading),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
