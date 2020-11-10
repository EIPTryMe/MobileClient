import 'package:tryme/Globals.dart';

enum productInfo_e { CARD }

class QueryParse {
  static void getUser(Map result) {
    user = User();
    user.id = result['id'];
    user.firstName = result['first_name'];
    user.lastName = result['name'];
    user.address = result['address'];
    user.phone = result['phone'];
    user.email = result['email'];
    user.birthDate = result['birth_date'];
    user.companyId = result['company_id'];
    user.picture = auth0User.picture;
  }

  static Product getProduct(Map result, [productInfo_e productInfo]) {
    Product product = Product();
    product.id = result['id'];
    product.name = result['name'];
    product.brand = result['brand'];
    product.stock = result['stock'];
    product.pricePerDay = result['price_per_day'] != null
        ? result['price_per_day'].toDouble()
        : null;
    product.pricePerWeek = result['price_per_week'] != null
        ? result['price_per_week'].toDouble()
        : null;
    product.pricePerMonth = result['price_per_month'] != null
        ? result['price_per_month'].toDouble()
        : null;
    product.stock = result['stock'];
    if (productInfo != productInfo_e.CARD) {
      product.description = result['description'];
      product.specifications = result['product_specifications'];
    }
    product.reviews = Reviews(reviews: List());
    (result['reviews'] as List).forEach((element) {
      product.reviews.reviews.add(productInfo != productInfo_e.CARD
          ? Review(
              score: element['score'].toDouble(),
              description: element['description'])
          : Review(score: element['score'].toDouble()));
    });
    product.reviews.computeAverageRating();
    if (result['picture'] != null) {
      product.pictures = List();
      product.pictures.add(result['picture']['url']);
    }
    return (product);
  }

  static void getShoppingCard(List result) {
    shoppingCard.clear();
    result.forEach((element) {
      Product product = Product();
      product.id = element['product']['id'];
      product.name = element['product']['name'];
      product.pricePerDay = element['product']['price_per_day'] != null
          ? element['product']['price_per_day'].toDouble()
          : null;
      product.pricePerWeek = element['product']['price_per_week'] != null
          ? element['product']['price_per_week'].toDouble()
          : null;
      product.pricePerMonth = element['product']['price_per_month'] != null
          ? element['product']['price_per_month'].toDouble()
          : null;
      if (element['product']['picture'] != null) {
        product.pictures = List();
        product.pictures.add(element['product']['picture']['url']);
      }
      Cart cart = Cart(product: product);
      shoppingCard.add(cart);
    });
  }

  static Order getOrder(Map result) {
    Order order = Order();
    List<Product> products = List();
    double total = 0;

    order.id = result['id'];
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
      category.name = element['name'];
      category.picture = element['image'];
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

  static String modifyUserAddress(String uid, String address) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {address: "$address"}) {
      affected_rows
    }
  }
  ''';

  static String modifyProduct(
          int id,
          String title,
          String brand,
          double monthPrice,
          double weekPrice,
          double dayPrice,
          int stock,
          String description) =>
      '''
  mutation {
    update_product(_set: {name: "$title", brand: "$brand", price_per_month: "$monthPrice", price_per_week: "$weekPrice", price_per_day: "$dayPrice", stock: $stock, description: "$description"}, where: {id: {_eq: $id}}) {
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
      price_per_day
      price_per_week
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

  static String products(String sort) => '''
  query {
    product($sort) {
      id
      name
      brand
      price_per_week
      price_per_month
      price_per_day
      stock
      picture {
        url
      }
      reviews {
        score
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
          price_per_week
          price_per_month
          price_per_day
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
