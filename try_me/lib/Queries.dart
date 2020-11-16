import 'package:tryme/Globals.dart';
import 'package:tryme/tools/AddressTool.dart';

enum productInfo_e { CARD }

class QueryParse {
  static Future getUser(Map result) async {
    user = User();
    if (user.picture == null) print('fuck');
    if (result['id'] != null) user.id = result['id'];
    if (result['first_name'] != null) user.firstName = result['first_name'];
    if (result['name'] != null) user.lastName = result['name'];
    if (result['address'] != null) user.address.street = result['address'];
    if (result['city'] != null) user.address.city = result['city'];
    if (result['postcode'] != null) user.address.postCode = result['postcode'];
    if (result['country'] != null) user.address.country = result['country'];
    user.address.fullAddress = await AddressTool.getAddressFromString(
        '${user.address.street} ${user.address.postCode} ${user.address.city} ${user.address.country}');
    if (result['phone'] != null) user.phone = result['phone'];
    if (result['email'] != null) user.email = result['email'];
    if (result['birth_date'] != null) user.birthday = result['birth_date'];
    user.companyId = result['company_id'];
    user.picture = auth0User.picture;
  }

  static Product getProduct(Map result, [productInfo_e productInfo]) {
    Product product = Product();

    if (result['id'] != null) product.id = result['id'];
    if (result['name'] != null) product.name = result['name'];
    if (result['brand'] != null) product.brand = result['brand'];
    if (result['stock'] != null) product.stock = result['stock'];
    if (result['price_per_month'] != null)
      product.pricePerMonth = result['price_per_month'] != null
          ? result['price_per_month'].toDouble()
          : null;
    if (result['stock'] != null) product.stock = result['stock'];
    if (productInfo != productInfo_e.CARD) {
      if (result['description'] != null)
        product.description = result['description'];
      if (result['product_specifications'] != null)
        product.specifications = result['product_specifications'];
    }
    if (result['reviews'] != null) {
      (result['reviews'] as List).forEach((element) {
        product.reviews.reviews.add(productInfo != productInfo_e.CARD
            ? Review(
                score: element['score'].toDouble(),
                description: element['description'])
            : Review(score: element['score'].toDouble()));
      });
      product.reviews.computeAverageRating();
    }
    if (result['picture'] != null) {
      product.pictures.add(result['picture']['url']);
    }
    return (product);
  }

  static List<Cart> getShoppingCard(List result) {
    List<Cart> shoppingCard = List();

    result.forEach((element) {
      Product product = Product();
      if (element['product'] != null) {
        if (element['product']['id'] != null)
          product.id = element['product']['id'];
        if (element['product']['name'] != null)
          product.name = element['product']['name'];
        if (element['product']['price_per_month'] != null)
          product.pricePerMonth =
              element['product']['price_per_month'].toDouble();
        if (element['product']['picture'] != null) {
          if (element['product']['picture']['url'] != null)
            product.pictures.add(element['product']['picture']['url']);
        }
        shoppingCard.add(Cart(product: product, quantity: 1));
      }
    });
    return (shoppingCard);
  }

  static Order getOrder(Map result) {
    Order order = Order();
    List<Product> products = List();
    double total = 0;

    if (result['id'] != null) order.id = result['id'];
    if (result['order_statuses'] != null &&
        (result['order_statuses'] as List).isNotEmpty &&
        result['order_statuses'][0]['status'] != null)
      order.status = result['order_statuses'][0]['status'];

    (result['order_items'] as List).forEach((element) {
      products.add(getProduct(element['product']));
      total += products.last.pricePerMonth;
    });
    order.products = products;
    order.total = total;
    return (order);
  }

  static void getCategories(List result) {
    result.forEach((element) {
      Category category = Category();
      if (element['name'] != null) category.name = element['name'];
      if (element['image'] != null) category.picture = element['image'];
      categories.add(category);
    });
  }
}

class Mutations {
  static String addProduct(int id) => '''
  mutation {
    createCartItem(product_id: $id) {
      id
    }
  }
  ''';

  static String deleteShoppingCard(String user_uid, int product_id) => '''
  mutation {
    delete_cart(where: {product_id: {_eq: $product_id}, user_uid: {_eq: "$user_uid"}}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserFirstName(String uid, String firstName) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {first_name: "$firstName"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserName(String uid, String name) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {name: "$name"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserPhone(String uid, String phone) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {phone: "$phone"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserEmail(String uid, String email) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {email: "$email"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserBirthday(String uid, String birthday) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {birth_date: "$birthday"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserAddress(String uid, String street, String postcode,
          String city, String country) =>
      '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {address: "$street", postcode: "$postcode", city: "$city", country: "$country"}) {
      affected_rows
    }
  }
  ''';

  static String modifyProduct(int id, String title, String brand,
          double monthPrice, int stock, String description) =>
      '''
  mutation {
    update_product(_set: {name: "$title", brand: "$brand", price_per_month: "$monthPrice", stock: $stock, description: "$description"}, where: {id: {_eq: $id}}) {
      affected_rows
    }
  }
  ''';

  static String orderPayment(String currency, String city, String country,
          String address, int postalCode) =>
      '''
  mutation {
    orderPayment(currency: "$currency", addressDetails: {address_city: "$city", address_country: "$country", address_line_1: "$address", address_postal_code: $postalCode}) {
      order_id
      clientSecret
      publishableKey
    }
  }
  ''';

  static String payOrder(int orderId) => '''
  mutation {
    payOrder(order_id: $orderId) {
      stripe_id
    }
  }
  ''';
}

class Queries {
  static String product(int id) => '''
  query {
    product(where: {id: {_eq: $id}}) {
      id
      name
      brand
      price_per_month
      stock
      description
      product_specifications {
        name
      }
      picture {
        url
      }
      reviews {
        description
        score
      }
    }
  }
  ''';

  static String products(String category) => '''
  query {
    product(where: {category: {name: {_eq: "$category"}}}) {
      id
      name
      price_per_month
      picture {
        url
      }
    }
  }
  ''';

  static String productsSearch(String keywords) => '''
  query {
    product(where: {name: {_ilike: "%$keywords%"}}) {
      id
      name
      price_per_month
      picture {
        url
      }
    }
  }
  ''';

  static String shoppingCard(String uid) => '''
  query {
    user(where: {uid: {_eq: "$uid"}}) {
      cartsUid {
        product {
          id
          name
          price_per_month
          picture {
            url
          }
        }
      }
    }
  }
  ''';

  static String orders(String status) =>
      '''
  query {
    order(where: {''' +
      (status.isEmpty
          ? ""
          : '''order_statuses: {status: {_eq: "$status"}}, ''') +
      '''user_uid: {_eq: "${auth0User.uid}"}}, order_by: {created_at: desc}) {
      order_items {
         product {
          id
          name
          brand
          price_per_month
          stock
          picture {
            url
          }
          reviews {
            score
          }
        }
      }
      id
      order_statuses {
        status
      }
    }
  }
  ''';

  static String ordersNumber(String status) => '''
  query MyQuery {
    order_aggregate(where: {user_uid: {_eq: "${auth0User.uid}"}}) {
      aggregate {
        count
      }
    }
  }
  ''';

  static String user(String uid) => '''
  query {
    user(where: {uid: {_eq: "$uid"}}) {
      id
      first_name
      name
      address
      city
      country
      postcode
      birth_date
      phone
      email
      company_id
    }
  }
  ''';

  static String categories() => '''
  query {
    category {
      name
      image
    }
  }
  ''';
}
