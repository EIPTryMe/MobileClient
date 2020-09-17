import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  FluroRouter.setupRouter();
  runApp(GraphQLProvider(
    child: CacheProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        onGenerateRoute: FluroRouter.router.generator,
      ),
    ),
    client: graphQLConfiguration.client,
  ));
}
