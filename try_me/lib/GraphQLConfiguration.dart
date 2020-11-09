import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  GraphQLConfiguration() {
    initClient();
  }

  ValueNotifier<GraphQLClient> client;

  void initClient({uid}) {
    Map<String, String> headers = Map();
    HttpLink httpLink;

    headers['x-hasura-admin-secret'] = 'aUCyUfhw8eNxR35se7IzQ4D1yEQvB8vu';
    if (uid != null) headers['x-hasura-user-id'] = uid;
    httpLink = HttpLink(
      uri: 'https://tryme-backend.herokuapp.com/v1/graphql',
      headers: headers,
    );
    this.client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: NormalizedInMemoryCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
  }
}
