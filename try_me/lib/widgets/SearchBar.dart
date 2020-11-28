import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchBar extends StatefulWidget {
  SearchBar({this.text, this.onSubmitted, this.height = 50.0});

  final String text;
  final Function(String) onSubmitted;
  final double height;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Function _onSubmitted;
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    _onSubmitted = widget.onSubmitted;
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextFormField(
        controller: _controller,
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
          contentPadding: EdgeInsets.symmetric(vertical: widget.height / 2 - 10),
        ),
        onFieldSubmitted: (keywords) {
          if (keywords.isNotEmpty) {
            _onSubmitted(keywords);
          }
        },
      ),
    );
  }
}
