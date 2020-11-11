import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:tryme/App.dart';
import 'package:tryme/views/AuthentificationView.dart';
import 'package:tryme/views/LandingView.dart';
import 'package:tryme/views/OrdersView.dart';
import 'package:tryme/views/OrderDeliveryOptionsView.dart';
import 'package:tryme/views/OrderFinishedView.dart';
import 'package:tryme/views/ProductListCategoryView.dart';
import 'package:tryme/views/ProductView.dart';
import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/views/SignInView.dart';
import 'package:tryme/views/SignUpView.dart';

class FluroRouter {
  static fluro.Router router = fluro.Router();
  static fluro.Handler _appIndexHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App(index: params['index'][0]));
  static fluro.Handler _appHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App());
  static fluro.Handler _authentificationHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          AuthentificationView());
  static fluro.Handler _landingHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LandingView());
  static fluro.Handler _ordersHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersView(status: params['status'][0]));
  static fluro.Handler _orderDeliveryOptionsHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrderDeliveryOptionsView());
  static fluro.Handler _orderFinishedHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrderFinishedView());
  static fluro.Handler _productListCategoryHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductListCategoryView(category: params['category'][0]));
  static fluro.Handler _productHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(id: params['id'][0]));
  static fluro.Handler _shoppingCardHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ShoppingCardView());
  static fluro.Handler _signInHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignInView());
  static fluro.Handler _signUpHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignUpView());

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
      'authentification',
      handler: _authentificationHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'landing',
      handler: _landingHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'orders/:status',
      handler: _ordersHandler,
      transitionType: fluro.TransitionType.cupertinoFullScreenDialog,
    );
    router.define(
      'orderDeliveryOptions',
      handler: _orderDeliveryOptionsHandler,
      transitionType: fluro.TransitionType.cupertinoFullScreenDialog,
    );
    router.define(
      'orderFinished',
      handler: _orderFinishedHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'productListCategory/:category',
      handler: _productListCategoryHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
    router.define(
      'product/:id',
      handler: _productHandler,
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
      'signUp',
      handler: _signUpHandler,
      transitionType: fluro.TransitionType.cupertino,
    );
  }
}
