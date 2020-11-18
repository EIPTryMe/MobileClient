library my_prj.globals;

import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/GraphQLConfiguration.dart';

class Auth0User {
  Auth0User({this.uid = "", this.picture = "", this.isEmailVerified = false});

  String uid;
  String picture;
  bool isEmailVerified;
}

class User {
  User(
      {this.id = 0,
      this.firstName = "",
      this.lastName = "",
      this.address,
      this.phone = "",
      this.email = "",
      this.birthday = "",
      this.picture = "",
      this.companyId = 0}) {
    if (address == null) address = UserAddress();
  }

  int id;
  String firstName;
  String lastName;
  UserAddress address;
  String phone;
  String email;
  String birthday;
  String picture;
  int companyId;
}

class UserAddress {
  UserAddress(
      {this.street = "",
      this.postCode = "",
      this.city = "",
      this.country = "",
      this.fullAddress}) {
    if (fullAddress == null) fullAddress = Address();
  }

  String street;
  String postCode;
  String city;
  String country;
  Address fullAddress;
}

class Review {
  Review({this.score = 0.0, this.description = ""});

  double score;
  String description;
}

class Reviews {
  Reviews({this.reviews, this.averageRating = 0.0}) {
    if (reviews == null) reviews = List();
  }

  List<Review> reviews;
  double averageRating;
}

class Product {
  Product(
      {this.id = 0,
      this.name = "",
      this.brand = "",
      this.pricePerMonth = 0.0,
      this.stock = 0,
      this.description = "",
      this.specifications,
      this.reviews,
      this.pictures}) {
    if (specifications == null) specifications = List();
    if (reviews == null) reviews = Reviews();
    if (pictures == null) pictures = List();
  }

  int id;
  String name;
  String brand;
  double pricePerMonth;
  int stock;
  String description;
  List specifications;
  Reviews reviews;
  List pictures;
}

class Cart {
  Cart({this.product, this.quantity = 0}) {
    if (product == null) product = Product();
  }

  Product product;
  int quantity;
}

class Order {
  Order({this.id, this.total, this.status, this.products}) {
    id = 0;
    total = 0.0;
    status = "";
    products = List();
  }

  int id;
  double total;
  String status;
  List<Product> products;
}

class Category {
  Category({this.name, this.picture}) {
    name = "";
    picture = "";
  }

  String name;
  String picture;
}

ValueNotifier<GraphQLClient> client = getGraphQLClient();

bool isLoggedIn = false;

Auth0User auth0User = Auth0User();
User user = User();

List<Category> categories = List();
List<Cart> shoppingCard = List();

const String mapApiKey = 'AIzaSyBOfQxDPTnCGCVw-OMy4yt4Iy9LgMCKbcQ';
