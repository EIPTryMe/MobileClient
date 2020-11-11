import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  double _height = 50;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.black.withOpacity(0.5),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: 'Rechercher...',
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: _height / 2 - 10),
          ),
        ),
      ),
    );
  }
}
