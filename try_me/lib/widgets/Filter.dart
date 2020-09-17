import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  Filter(this.callback);

  final Function callback;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List _options = [
    "Nom A-Z",
    "Nom Z-A",
    "Prix croissant",
    "Prix décroissant",
    "Nouveautés"
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentOption;

  void changedDropDownItem(String option) {
    if (this.mounted)
      setState(() {
        _currentOption = option;
      });
    widget.callback(option);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String option in _options) {
      items.add(new DropdownMenuItem(value: option, child: new Text(option)));
    }
    return (items);
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentOption = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButton(
          value: _currentOption,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
        ),
      ),
    );
  }
}
