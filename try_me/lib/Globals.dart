library my_prj.globals;

import 'package:geocoder/geocoder.dart';

import 'package:tryme/GraphQLConfiguration.dart';

class Auth0User {
  Auth0User({this.uid, this.picture, this.isEmailVerified}) {
    uid = "";
    picture = "";
    isEmailVerified = false;
  }

  String uid;
  String picture;
  bool isEmailVerified;
}

class User {
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.phone,
      this.email,
      this.birthday,
      this.picture,
      this.companyId}) {
    id = 0;
    firstName = "";
    lastName = "";
    address = UserAddress();
    phone = "";
    email = "";
    birthday = "";
    picture = "";
    companyId = 0;
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
      {this.street, this.postCode, this.city, this.country, this.fullAddress}) {
    street = "";
    postCode = "";
    city = "";
    country = "";
    fullAddress = Address();
  }

  String street;
  String postCode;
  String city;
  String country;
  Address fullAddress;
}

class Review {
  Review({this.score, this.description}) {
    score = 0.0;
    description = "";
  }

  double score;
  String description;
}

class Reviews {
  Reviews({this.reviews, this.averageRating}) {
    reviews = List();
    averageRating = 0.0;
  }

  void computeAverageRating() {
    averageRating = 0.0;
    reviews.forEach((element) {
      averageRating += element.score;
    });
    averageRating /= reviews.length;
  }

  List<Review> reviews;
  double averageRating;
}

class Product {
  Product(
      {this.id,
      this.name,
      this.brand,
      this.pricePerMonth,
      this.stock,
      this.description,
      this.specifications,
      this.reviews,
      this.pictures}) {
    id = 0;
    name = "";
    brand = "";
    pricePerMonth = 0.0;
    stock = 0;
    description = "";
    specifications = List();
    reviews = Reviews();
    pictures = List();
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
  Cart({this.product, this.quantity}) {
    product = Product();
    quantity = 0;
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

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

bool isLoggedIn = false;

Auth0User auth0User = Auth0User();
User user = User();

List<Category> categories = List();
List<Cart> shoppingCard = List();

const String mapApiKey = 'AIzaSyBOfQxDPTnCGCVw-OMy4yt4Iy9LgMCKbcQ';
