import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class GoBackTopBar extends StatelessWidget {
  GoBackTopBar({this.title = ""});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Styles.colors.text,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            this.title,
            style: TextStyle(
              color: Styles.colors.text,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
