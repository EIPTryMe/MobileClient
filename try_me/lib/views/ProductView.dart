import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/GraphQLConfiguration.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/Loading.dart';

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
    graphQLConfiguration = GraphQLConfiguration();
    result = await graphQLConfiguration.clientToQuery.query(queryOption);
    if (this.mounted) {
      setState(() {
        product = QueryParse.getProduct(result.data['product'][0]);
      });
    }
  }

  void addProduct(BuildContext context) async {
    if (auth0User.uid == null) return;
    Loading.showLoadingDialog(context);
    Request.addProductShoppingCard(int.parse(widget.id)).whenComplete(() {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Produit ajouté',
          textAlign: TextAlign.center,
        ),
      ));
      Loading.closeLoadingDialog();
    });
    //Request.getShoppingCard();
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
}
