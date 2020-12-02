import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';

class FilterOptions {
  List<String> brands = List();
  List<String> selectedBrands = List();
  List<String> categories = List();
  String selectedCategory = '';
  RangeValues priceRange = RangeValues(0.0, 0.0);
  RangeValues priceCurrent = RangeValues(0.0, 0.0);
}

class Filter extends StatefulWidget {
  Filter({this.filterOptions, this.onSubmit});

  final FilterOptions filterOptions;
  final Function onSubmit;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  FilterOptions _filterOptions = FilterOptions();
  int _categorySelectedIndex;
  RangeValues _priceCurrent = RangeValues(0, 0);

  @override
  void initState() {
    _filterOptions = widget.filterOptions;
    _categorySelectedIndex =
        _filterOptions.categories.indexOf(_filterOptions.selectedCategory);
    _priceCurrent = widget.filterOptions.priceCurrent == RangeValues(0.0, 0.0)
        ? widget.filterOptions.priceRange
        : widget.filterOptions.priceCurrent;
    if (_priceCurrent.start < widget.filterOptions.priceRange.start)
      _priceCurrent =
          RangeValues(widget.filterOptions.priceRange.start, _priceCurrent.end);
    if (_priceCurrent.end > widget.filterOptions.priceRange.end)
      _priceCurrent =
          RangeValues(_priceCurrent.start, widget.filterOptions.priceRange.end);
    super.initState();
  }

  Widget _categories() {
    return Container(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Catégories',
            style: TextStyle(color: Styles.colors.text),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.categories.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ChoiceChip(
                        label: Text(
                          _filterOptions.categories[index],
                          style: TextStyle(color: Styles.colors.text),
                        ),
                        selectedColor: Styles.colors.main,
                        backgroundColor: Styles.colors.lightBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        selected: _categorySelectedIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _categorySelectedIndex = index;
                              _filterOptions.selectedCategory =
                                  _filterOptions.categories[index];
                            } else {
                              _categorySelectedIndex = null;
                              _filterOptions.selectedCategory = '';
                            }
                          });
                        },
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  Widget _brand() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Marques',
            style: TextStyle(color: Styles.colors.text),
          ),
          Expanded(
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              childAspectRatio: 0.35,
              children: _filterOptions.brands
                  .map((brand) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FilterChip(
                          label: Container(
                            width: 100,
                            child: Text(
                              brand,
                              style: TextStyle(color: Styles.colors.text),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          selectedColor: Styles.colors.main,
                          backgroundColor: Styles.colors.lightBackground,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          selected:
                              _filterOptions.selectedBrands.contains(brand),
                          onSelected: (selected) {
                            setState(() {
                              if (_filterOptions.selectedBrands.contains(brand))
                                _filterOptions.selectedBrands.remove(brand);
                              else
                                _filterOptions.selectedBrands.add(brand);
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _price() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Prix',
          style: TextStyle(color: Styles.colors.text),
        ),
        Row(
          children: [
            Text(
              '${_priceCurrent.start.round()}€',
              style: TextStyle(color: Styles.colors.text),
            ),
            Expanded(
              child: RangeSlider(
                min: widget.filterOptions.priceRange.start,
                max: widget.filterOptions.priceRange.end,
                activeColor: Styles.colors.main,
                values: _priceCurrent,
                labels: RangeLabels(
                  _priceCurrent.start.round().toString(),
                  _priceCurrent.end.round().toString(),
                ),
                onChanged: (range) {
                  setState(() {
                    _priceCurrent = range;
                    _filterOptions.priceCurrent = range;
                  });
                },
              ),
            ),
            Text(
              '${_priceCurrent.end.round()}€',
              style: TextStyle(color: Styles.colors.text),
            ),
          ],
        ),
      ],
    );
  }

  Widget _submit() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        color: Styles.colors.main,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: () {
          widget.onSubmit(_filterOptions);
          Navigator.pop(context);
        },
        child: Text(
          'Appliquer',
          style: TextStyle(color: Styles.colors.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _categories(),
                SizedBox(height: 20),
                _brand(),
                SizedBox(height: 20),
                _price(),
              ],
            ),
          ),
          _submit(),
        ],
      ),
    );
  }
}
