import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/GraphQLConfiguration.dart';
import 'package:tryme/widgets/OrderCard.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';

class UserOrdersView extends StatefulWidget {
  UserOrdersView({Key key, this.orderStatus}) : super(key: key);
  final String orderStatus;

  @override
  _UserOrdersViewState createState() => _UserOrdersViewState();
}

class _UserOrdersViewState extends State<UserOrdersView> {
  List<Order> orders = List();

  void getData() async {
    QueryResult result;
    QueryOptions queryOptions;

    if (widget.orderStatus == 'Non payées')
      queryOptions = QueryOptions(
          documentNode: gql(Queries.orders('waiting for payment')));
    else if (widget.orderStatus == 'Payées')
      queryOptions = QueryOptions(documentNode: gql(Queries.orders('paid')));
    else if (widget.orderStatus == 'Mes Commandes')
      queryOptions = QueryOptions(documentNode: gql(Queries.ordersAll()));
    graphQLConfiguration = GraphQLConfiguration();
    result = await graphQLConfiguration.clientToQuery.query(queryOptions);
    if (this.mounted)
      setState(() {
        orders.clear();
        (result.data['order'] as List).forEach((order) {
          List<Product> products = List();
          String status = order['order_statuses'] != null
              ? order['order_statuses'][0]['status']
              : null;
          double total = 0;
          (order['order_items'] as List).forEach((item) {
            products.add(QueryParse.getProduct(item['product']));
            total += item['price'].toDouble();
          });
          orders.add(Order(
              id: order['id'],
              status: status,
              total: total,
              products: products));
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
          title: Text(widget.orderStatus),
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
          title: Text(widget.orderStatus),
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
