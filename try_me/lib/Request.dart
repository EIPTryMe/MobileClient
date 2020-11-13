import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/GraphQLConfiguration.dart';
import 'package:tryme/Queries.dart';

enum OrderBy { PRICE, NEW, NAME }

class Request {
  static Future getShoppingCard() async {
    if (auth0User.uid == null) return;
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.shoppingCard(auth0User.uid)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    QueryParse.getShoppingCard(result.data['user'][0]['cartsUid']);
  }

  static void deleteShoppingCard(int id) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.deleteShoppingCard(auth0User.uid, id)));
    result = await graphQLConfiguration.client.value.query(queryOption);
  }

  static Future<void> getUser() async {
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.user(auth0User.uid)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    await QueryParse.getUser(result.data['user'][0]);
  }

  static Future<void> getCategories() async {
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.categories()));
    result = await graphQLConfiguration.client.value.query(queryOption);
    QueryParse.getCategories(result.data['category']);
  }

  static Future<bool> modifyUserFirstName(String firstName) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserFirstName(
            auth0User.uid, firstName != null ? firstName : "")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future<bool> modifyUserName(String name) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(
            Mutations.modifyUserName(auth0User.uid, name != null ? name : "")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future<bool> modifyUserPhone(String phone) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserPhone(
            auth0User.uid, phone != null ? phone : "")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future<bool> modifyUserEmail(String email) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserEmail(
            auth0User.uid, email != null ? email : "")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future<bool> modifyUserBirthday(String birthday) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserBirthday(
            auth0User.uid, birthday != null ? birthday : "")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future<bool> modifyUserAddress(
      String street, String postcode, String city, String country) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserAddress(
            auth0User.uid, street, postcode, city, country)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.hasException);
  }

  static Future modifyProduct(Product product) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyProduct(
            product.id,
            product.name,
            product.brand,
            product.pricePerMonth,
            product.stock,
            product.description.replaceAll('\n', '\\n'))));
    result = await graphQLConfiguration.client.value.query(queryOption);
  }

  static Future order(String currency, String city, String country,
      String address, int postalCode) async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.orderPayment(
            currency, city, country, address, postalCode)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    return (result.data['orderPayment']);
  }

  static Future payOrder(int orderId) async {
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Mutations.payOrder(orderId)));
    result = await graphQLConfiguration.client.value.query(queryOption);
  }

  static Future<List<Product>> getProducts(String category) async {
    List<Product> products = List();
    QueryResult result;
    QueryOptions queryOption =
    QueryOptions(documentNode: gql(Queries.products(category)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    (result.data['product'] as List).forEach((element) {
      products.add(QueryParse.getProduct(element));
    });
    return (products);
  }

  static Future addProductShoppingCard(int id) async {
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Mutations.addProduct(id)));
    result = await graphQLConfiguration.client.value.query(queryOption);
  }

  static Future<List<Order>> getOrders(String status) async {
    List<Order> orders = List();
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.orders(status)));
    result = await graphQLConfiguration.client.value.query(queryOption);
    (result.data['order'] as List).forEach((element) {
      orders.add(QueryParse.getOrder(element));
    });
    return (orders);
  }

  static Future<int> getOrdersNumber() async {
    int ordersNumber = 0;
    QueryResult result;
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.ordersNumber("")));
    result = await graphQLConfiguration.client.value.query(queryOption);
    if (!result.hasException)
      ordersNumber = result.data['order_aggregate']['aggregate']['count'];
    return (ordersNumber);
  }
}
