import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';

class ProductView extends StatefulWidget {
  ProductView({this.id});

  final String id;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Product _product = Product();
  String _pricePerMonth = "";
  bool _loading = true;
  int _duration = 1;
  ButtonState _buttonState = ButtonState.idle;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    int id;

    if (widget.id != null) id = int.tryParse(widget.id);
    if (id != null)
      Request.getProduct(id).then((product) {
        setState(() {
          _product = product;
          _pricePerMonth = NumberFormatTool.formatPrice(_product.pricePerMonth);
          _loading = false;
        });
      });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            initialIntegerValue: _duration,
            minValue: 1,
            maxValue: 24,
            title: Text("Durée de la location (mois)"),
          );
        }).then((value) {
      if (value != null) setState(() => _duration = value);
    });
  }

  Widget _carouselFullScreen({List images, int current}) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: CarouselSlider(
          items: images
              .map((item) => GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.network(
                      item,
                      height: height,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              height: height, viewportFraction: 1.0, initialPage: current),
        ),
      ),
    );
  }

  Widget _carousel({double height = 400.0}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Styles.cardRadius),
      ),
      child: _product.pictures == null
          ? null
          : ClipRRect(
              borderRadius: BorderRadius.circular(Styles.cardRadius),
              child: CarouselSlider(
                items: _product.pictures == null
                    ? null
                    : _product.pictures
                        .asMap()
                        .map(
                          (i, item) => MapEntry(
                            i,
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => _carouselFullScreen(
                                      images: _product.pictures, current: i),
                                ),
                              ),
                              child: Image.network(
                                item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                //width: width,
                              ),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                options: CarouselOptions(height: height, viewportFraction: 1.0),
              ),
            ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                _product.name,
                style: TextStyle(color: Styles.colors.title),
              ),
            ),
            _product.reviews.reviews.isEmpty
                ? Text('Pas encore noté',
                    style: TextStyle(color: Styles.colors.title))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(5, (index) {
                      IconData icon;

                      if (_product.reviews.averageRating.floor() >= index + 1)
                        icon = Icons.star;
                      else if (_product.reviews.averageRating.round() ==
                          index + 1)
                        icon = Icons.star_half;
                      else
                        icon = Icons.star_border;
                      return Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      );
                    }),
                  ),
          ],
        ),
        SizedBox(height: 3),
        Text(
          '$_pricePerMonth€ / mois',
          style: TextStyle(color: Styles.colors.text),
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Description:',
          style: TextStyle(
              color: Styles.colors.title, decoration: TextDecoration.underline),
        ),
        SizedBox(height: 10),
        Text(
          _product.description,
          style: TextStyle(color: Styles.colors.title),
        ),
      ],
    );
  }

  Widget _specification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spécification:',
          style: TextStyle(
              color: Styles.colors.title, decoration: TextDecoration.underline),
        ),
        SizedBox(height: 10),
        Column(
          children: _product.specifications
              .map((spec) => Text(
                    spec,
                    style: TextStyle(color: Styles.colors.title),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _productInfo() {
    return ListView(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      children: [
        _carousel(),
        SizedBox(height: 10),
        _header(),
        SizedBox(height: 30),
        _description(),
        if (_product.specifications.isNotEmpty) SizedBox(height: 30),
        if (_product.specifications.isNotEmpty) _specification(),
      ],
    );
  }

  Widget _addButton() {
    double width = MediaQuery.of(context).size.width;

    return ProgressButton.icon(
      maxWidth: width,
      radius: Styles.buttonRadius,
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Ajouter au panier",
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            color: Styles.colors.main),
        ButtonState.loading: IconedButton(color: Styles.colors.main),
        ButtonState.fail: IconedButton(
            text: "Erreur",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.withOpacity(0.7)),
        ButtonState.success: IconedButton(
            text: "Produit ajouté au panier",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: () {
        if (isLoggedIn == false) {
          Navigator.pushNamed(context, 'signIn');
          return;
        }
        setState(() {
          _buttonState = ButtonState.loading;
        });
        Request.addProductShoppingCard(_product.id, _duration)
            .then((hasException) {
          setState(() {
            _buttonState =
                hasException ? ButtonState.fail : ButtonState.success;
          });
        });
      },
      state: _buttonState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Styles.mainHorizontalPadding),
              child: GoBackTopBar(title: _product.name, titleFontSize: 24.0),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _productInfo(),
                  Loading(active: _loading),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Styles.mainHorizontalPadding,
                right: Styles.mainHorizontalPadding,
                top: 8.0,
                bottom: 15.0,
              ),
              child: Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _addButton()),
                    SizedBox(width: 8),
                    Container(
                      width: 85,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.blue,
                        onPressed: () => _showDialog(),
                        child: Text(
                          '$_duration mois',
                          style: TextStyle(color: Styles.colors.text),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
