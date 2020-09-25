import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/GraphQLConfiguration.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/widgets/OrderCard.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/widgets/Orders.dart';

class OrdersView extends StatefulWidget {
  OrdersView({this.status});

  final String status;

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  List<Order> orders = List();

  void getData() async {
    Request.getOrders(widget.status).then((value) {
      if (this.mounted)
        setState(() {
          orders = value;
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
    if (orders.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
          backgroundColor: Color(0xff1F2C47),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.assignment,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'Vous n\'avez pas de commandes',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
          backgroundColor: Color(0xff1F2C47),
        ),
        body: ListView(
          children: orders
              .map((order) => Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: OrderCard(
              order: order,
            ),
          ))
              .toList(),
        ),
      );
    }
  }
}
