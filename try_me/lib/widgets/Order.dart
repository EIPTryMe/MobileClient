import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tryme/widgets/OrderCard.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  double borderRadius = 12.0;

  Widget _orderFilter() {
    return Container(
      color: Colors.white,
      height: 150,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Commandes",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
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
                        onPressed: () => Navigator.pushNamed(context, 'userOrders/Mes Commandes'),
                      ),
                      Text("Mes commandes"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.assignment, color: Color(0xff1F2C47)),
                        iconSize: 50.0,
                        onPressed: () => Navigator.pushNamed(context, 'userOrders/Non payées'),
                      ),
                      Text("Non-payées"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(children: [
                      IconButton(
                        icon: Icon(Icons.assignment),
                        iconSize: 50.0,
                        color: Color(0xff1F2C47),
                        onPressed: () => Navigator.pushNamed(context, 'userOrders/Payées'),
                      ),
                      Text("Payées"),
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
