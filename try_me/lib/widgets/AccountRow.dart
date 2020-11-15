import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class AccountRow extends StatefulWidget {
  @override
  _AccountRowState createState() => _AccountRowState();
}

class _AccountRowState extends State<AccountRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Styles.colors.iconAccount,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
            style: TextStyle(
              color: Styles.colors.title,
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Styles.colors.title, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Styles.colors.title, width: 1.0)),
                hintText: "Email",
                hintStyle: TextStyle(
                  color: Styles.colors.title,
                  fontSize: 13.0,
                )),
          ),
        )),
      ],
    );
  }
}
