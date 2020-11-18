import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

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
        Request.addProductShoppingCard(_product.id).then((hasException) {
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
              child: _addButton(),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

class ProductView extends StatefulWidget {
  ProductView({this.id});

  final String id;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Product product = Product();
  bool gotData = false;
  String formattedPrice;
  String formattedRating;
  Uint8List pictureBytes;

  Future getData() async {
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.product(int.parse(widget.id))));
    result = await client.value.query(queryOption);
    if (this.mounted) {
      setState(() {
        product = QueryParse.getProduct(result.data['product'][0]);
      });
    }
  }

  void addProduct(BuildContext context) async {
    Request.addProductShoppingCard(int.parse(widget.id)).then((hasException) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          hasException ? 'Erreur' : 'Produit ajouté',
          textAlign: TextAlign.center,
        ),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    getData().whenComplete(() {
      if (this.mounted)
        setState(() {
          gotData = true;
          formattedPrice = NumberFormatTool.formatPrice(product.pricePerMonth);
          formattedRating =
              NumberFormatTool.formatRating(product.reviews.averageRating);
        });
    });
  }

  Widget _carousel() {
    return Container(
      color: Colors.grey[300],
      height: 400,
      child: product.pictures == null
          ? null
          : Builder(builder: (context) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              return CarouselSlider(
                items: product.pictures == null
                    ? null
                    : product.pictures
                        .asMap()
                        .map((i, item) => MapEntry(
                              i,
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CarouselFullscreen(
                                                images: product.pictures,
                                                current: i))),
                                child: Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: width,
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                options: CarouselOptions(height: height, viewportFraction: 1.0),
              );
            }),
    );
  }

  Widget _mainInfo() {
    return !gotData
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    formattedPrice == null ? '' : '€ ' + formattedPrice,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(' / mois'),
                ],
              ),
              SizedBox(height: 10),
              Text(
                product.name == null ? '' : product.name,
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                product.brand == null ? '' : product.brand,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        formattedRating == null
                            ? Container()
                            : Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  children: [
                                    Text(formattedRating + ' '),
                                    Icon(
                                      Icons.star,
                                      size: 15.0,
                                      color: Colors.red[400],
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            product.stock > 0 ? 'Disponible ' : 'Indisponible ',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          Icon(
                            Icons.brightness_1,
                            size: 15,
                            color:
                                product.stock > 0 ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _description() {
    return Text(product.description == null ? '' : product.description);
  }

  Widget _specifications() {
    return product.specifications == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: product.specifications
                .map((value) => Text(value['name']))
                .toList(),
          );
  }

  Widget _reviewCard(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(NumberFormatTool.formatRating(review.score) + ' '),
            Icon(
              Icons.star,
              size: 15.0,
              color: Colors.red[400],
            ),
          ],
        ),
        Text(review.description == null ? '' : review.description),
      ],
    );
  }

  Widget _userReview() {
    return product.reviews == null ||
            product.reviews.reviews == null ||
            product.reviews.reviews.isEmpty
        ? Text(
            'Pas encore noté',
            textAlign: TextAlign.center,
          )
        : Column(
            children: product.reviews.reviews
                .map((review) => _reviewCard(review))
                .toList(),
          );
  }

  Widget _addButton() {
    if (isLoggedIn && gotData) {
      if (product.stock > 0)
        return Expanded(
          flex: 1,
          child: Builder(
            builder: (context) => FlatButton(
              color: Color(0xff58c24c),
              onPressed: () => addProduct(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ajouter au panier  ',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Icon(Icons.add_shopping_cart, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      else
        return Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[400],
            child: Center(
                child: Text('Indisponible',
                    style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
        );
    }
    return Container();
  }

  Widget _card(
      {Widget widget, String title, bool top = true, bool bottom = true}) {
    return Padding(
      padding:
          EdgeInsets.only(top: top ? 6.0 : 0.0, bottom: bottom ? 6.0 : 0.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
              widget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1F2C47),
        actions: !isLoggedIn
            ? null
            : [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, 'shoppingCard'),
                ),
              ],
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 12,
            child: ListView(
              children: <Widget>[
                _carousel(),
                _card(widget: _mainInfo(), title: '', top: false),
                _card(widget: _description(), title: 'Description'),
                _card(widget: _specifications(), title: 'Spécifications'),
                _card(widget: _userReview(), title: 'Notes utilisateurs'),
              ],
            ),
          ),
          _addButton(),
        ],
      ),
    );
  }
}

class CarouselFullscreen extends StatelessWidget {
  CarouselFullscreen({this.images, this.current});

  final List images;
  final int current;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          return CarouselSlider(
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
          );
        }),
      ),
    );
  }
}*/
