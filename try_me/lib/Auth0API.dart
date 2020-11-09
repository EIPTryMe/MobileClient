import 'package:flutter_auth0/flutter_auth0.dart';

import 'package:tryme/Globals.dart' as global;

enum SocialAuth_e { FACEBOOK, GOOGLE }

class Auth0API {
  static String domain = 'dev-2o6a8byc.eu.auth0.com';
  static String clientId = 'YIfBoxMsxuVG6iTGNlxX3g7lvecyzrVQ';

  static Auth0 auth0 = Auth0(baseUrl: 'https://$domain/', clientId: clientId);

  static Future<bool> register(String email, String password) async {
    try {
      var response = await auth0.auth.createUser({
        'email': email,
        'password': password,
        'connection': 'Username-Password-Authentication'
      });

      print('''
    \nid: ${response['_id']}
    \nusername/email: ${response['email']}
    ''');
      return (await login(email, password));
    } catch (e) {
      print(e);
      return (false);
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      var response = await auth0.auth.passwordRealm({
        'username': email,
        'password': password,
        'realm': 'Username-Password-Authentication'
      });

      print('''
    \nAccess Token: ${response['access_token']}
    ''');

      return (await userInfo(response['access_token']));
    } catch (e) {
      print(e);
      return (false);
    }
  }

  static Future<bool> webAuth(SocialAuth_e socialAuth) async {
    try {
      String connection = '';
      if (socialAuth == SocialAuth_e.FACEBOOK)
        connection = 'facebook';
      else if (socialAuth == SocialAuth_e.GOOGLE) connection = 'google-oauth2';
      var response = await auth0.webAuth.authorize({
        'connection': connection,
        'scope': 'openid profile email offline_access',
        'prompt': 'login',
      });
      DateTime now = DateTime.now();
      print('''
    \ntoken_type: ${response['token_type']}
    \nexpires_in: ${DateTime.fromMillisecondsSinceEpoch(response['expires_in'] + now.millisecondsSinceEpoch)}
    \nrefreshToken: ${response['refresh_token']}
    \naccess_token: ${response['access_token']}
    ''');
      return (await userInfo(response['access_token']));
    } catch (e) {
      print('Error: $e');
      return (false);
    }
  }

  static Future<bool> userInfo(String bearer) async {
    try {
      var authClient = Auth0Auth(auth0.auth.clientId, auth0.auth.client.baseUrl,
          bearer: bearer);
      var info = await authClient.getUserInfo();

      global.auth0User = global.Auth0User();
      global.auth0User.uid = info['sub'];
      global.auth0User.picture = info['picture'];
      global.auth0User.isEmailVerified = info['email_verified'];

      global.graphQLConfiguration.initClient(uid: global.auth0User.uid);

      print(info);

      return (true);
    } catch (e) {
      print(e);
      return (false);
    }
  }
}
