import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Category> _categories = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Request.getCategories().whenComplete(() {
      setState(() {
        _categories = categories;
      });
    });
  }

  Widget _categoryCard(Category category, int index) {
    double radius = 25.0;

    return Stack(
      children: [
        index == 0
            ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            category.name,
                            style: TextStyle(
                                color: Styles.colors.title, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Image(
                          image: NetworkImage(category.picture),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(radius)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image(
                            image: NetworkImage(category.picture),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: Styles.colors.title,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              onTap: () => Navigator.pushNamed(
                  context, 'productListCategory/${category.name}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listCategories() {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 12.0,
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(index == 0 ? 4 : 2, 3),
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) =>
            _categoryCard(_categories[index], index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _listCategories(),
        ],
      ),
    );
  }
}
