import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text('TryMe');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        if (isLoggedIn)
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'shoppingCard'),
            icon: Icon(Icons.shopping_cart),
          ),
      ],
      title: customSearchBar,
      centerTitle: true,
      backgroundColor: Color(0xff1F2C47),
    );
  }
}
