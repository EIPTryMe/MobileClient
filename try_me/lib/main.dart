import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  FluroRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GraphQLProvider(
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'app',
          //initialRoute: 'landing',
          onGenerateRoute: FluroRouter.router.generator,
          supportedLocales: [
            Locale('en'),
            Locale('it'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ),
      ),
      client: graphQLConfiguration.client,
    );
  }
}
