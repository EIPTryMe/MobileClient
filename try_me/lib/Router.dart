import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:tryme/App.dart';
import 'package:tryme/views/LandingView.dart';
import 'package:tryme/views/OrdersView.dart';
import 'package:tryme/views/OrderFinishedView.dart';
import 'package:tryme/views/ProductView.dart';
import 'package:tryme/views/PaymentView.dart';
import 'package:tryme/views/SearchResultView.dart';
import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/views/SignInView.dart';
import 'package:tryme/views/SignUpEmailView.dart';
import 'package:tryme/views/SignUpPasswordView.dart';

class FluroRouter {
  static fluro.Router router = fluro.Router();
  static fluro.Handler _appIndexHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App(index: params['index'][0]));
  static fluro.Handler _appHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App());
  static fluro.Handler _landingHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LandingView());
  static fluro.Handler _ordersHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersView());
  static fluro.Handler _orderFinishedHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrderFinishedView());
  static fluro.Handler _productHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(id: params['id'][0]));
  static fluro.Handler _searchResultHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SearchResultView(
              category: params['category'][0],
              keywords: params['keywords'][0]));
  static fluro.Handler _shoppingCardHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ShoppingCardView());
  static fluro.Handler _signInHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignInView());
  static fluro.Handler _signUpEmailViewHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignUpEmailView());
  static fluro.Handler _signUpPasswordViewHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignUpPasswordView(email: params['email'][0]));
  static fluro.Handler _paymentViewHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PaymentView());

  static void setupRouter() {
    router.define(
      'app/:index',
      handler: _appIndexHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'app',
      handler: _appHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'landing',
      handler: _landingHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'orders',
      handler: _ordersHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'orderFinished',
      handler: _orderFinishedHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'product/:id',
      handler: _productHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'searchResult/:category/:keywords',
      handler: _searchResultHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'shoppingCard',
      handler: _shoppingCardHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'signIn',
      handler: _signInHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'signUpEmail',
      handler: _signUpEmailViewHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'signUpPassword/:email',
      handler: _signUpPasswordViewHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'payment',
      handler: _paymentViewHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
  }
}
