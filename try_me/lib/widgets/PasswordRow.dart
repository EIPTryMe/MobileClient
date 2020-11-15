import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class PasswordRow extends StatefulWidget {
  final String content;

  PasswordRow({Key key, @required this.content}) : super(key: key);

  @override
  _PasswordRowState createState() => _PasswordRowState(content);
}

class _PasswordRowState extends State<PasswordRow> {
  bool _obscureText = true;
  String content;

  _PasswordRowState(this.content);

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: Styles.colors.iconLock,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
            obscureText: _obscureText,
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
                hintText: content,
                hintStyle: TextStyle(
                  color: Styles.colors.title,
                  fontSize: 13.0,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _toggle();
                  },
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_sharp
                        : Icons.visibility_off_sharp,
                    color: Styles.colors.title,
                  ),
                )),
          ),
        )),
      ],
    );
  }
}
