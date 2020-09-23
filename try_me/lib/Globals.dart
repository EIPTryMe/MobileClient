library my_prj.globals;

import 'package:tryme/GraphQLConfiguration.dart';

class Auth0User {
  Auth0User(
      {this.uid,
      this.username,
      this.picture,
      this.email,
      this.isEmailVerified});

  String uid;
  String username;
  String picture;
  String email;
  bool isEmailVerified = false;
  bool webLogged = false;
}

class User {
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.phoneNumber,
      this.email,
      this.birthDate,
      this.pathToAvatar});

  int id;
  String firstName;
  String lastName;
  String address;
  String phoneNumber;
  String email;
  String birthDate;
  String pathToAvatar;
  int companyId;
}

class Review {
  Review({this.score, this.description});

  double score;
  String description;
}

class Reviews {
  Reviews({this.reviews, this.averageRating});

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
      this.pricePerDay,
      this.pricePerWeek,
      this.pricePerMonth,
      this.stock,
      this.description,
      this.specifications,
      this.reviews,
      this.pictures});

  int id;
  String name;
  String brand;
  double pricePerDay;
  double pricePerWeek;
  double pricePerMonth;
  int stock;
  String description;
  List specifications;
  Reviews reviews;
  List pictures;
}

class Cart {
  Cart({this.product, this.quantity = 1});

  Product product;
  int quantity;
}

class Order {
  Order({this.id, this.total, this.status, this.products});

  int id;
  double total;
  String status;
  List<Product> products;
}

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

bool isLoggedIn = false;

Auth0User auth0User = Auth0User();
User user = User();

List<Cart> shoppingCard = List();
