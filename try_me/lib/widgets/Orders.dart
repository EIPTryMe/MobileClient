import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tryme/widgets/OrderCard.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  double borderRadius = 12.0;

  Widget _orderFilter() {
    return Container(
      color: Colors.white,
      height: 160,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Commandes",
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.assignment),
                        iconSize: 50.0,
                        color: Color(0xff1F2C47),
                        onPressed: () => Navigator.pushNamed(
                            context, 'orders/'),
                      ),
                      Text("Tout afficher"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.credit_card, color: Colors.red),
                        iconSize: 50.0,
                        onPressed: () => Navigator.pushNamed(
                            context, 'orders/waiting for payment'),
                      ),
                      Text("En attente"),
                      Text('de paiement'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.credit_card, color: Colors.green),
                        iconSize: 50.0,
                        color: Color(0xff1F2C47),
                        onPressed: () =>
                            Navigator.pushNamed(context, 'orders/paid'),
                      ),
                      Text("En attente"),
                      Text("d'expédition"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = height / 4;

    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          _orderFilter(),
        ],
      ),
    );
  }
}
