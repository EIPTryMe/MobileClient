import 'package:flutter/material.dart';

import 'package:tryme/Request.dart';

import 'package:tryme/widgets/AppBar.dart';
import 'package:tryme/widgets/Drawer.dart';
import 'package:tryme/widgets/Filter.dart';
import 'package:tryme/widgets/ProductCard.dart';
import 'package:tryme/Globals.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Product> products = List();

  void callback(String option) {
    getData(option);
  }

  void getData([String option]) async {
    OrderBy orderBy;
    bool asc;
    if (option == 'Nom A-Z' || option == null) {
      orderBy = OrderBy.NAME;
      asc = true;
    } else if (option == 'Nom Z-A') {
      orderBy = OrderBy.NAME;
      asc = false;
    } else if (option == 'Prix croissant') {
      orderBy = OrderBy.PRICE;
      asc = true;
    } else if (option == 'Prix décroissant') {
      orderBy = OrderBy.PRICE;
      asc = false;
    } else if (option == 'Nouveautés') {
      orderBy = OrderBy.NEW;
      asc = false;
    }
    Request.getProducts(orderBy, asc).then((products) {
      if (this.mounted)
        setState(() {
          this.products = products;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: isLoggedIn ? DrawerIsConnected() : DrawerNotConnected(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Filter(callback),
          ),
          Expanded(
            flex: 15,
            child: ListView(
              children: products
                  .map((product) => Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                        child: ProductCard(
                          product: product,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
