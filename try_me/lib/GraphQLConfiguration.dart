import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  GraphQLClient getClientToQuery(String uid) {
    HttpLink httpLink = HttpLink(
      uri: 'https://tryme-backend.herokuapp.com/v1/graphql',
      headers: <String, String>{
        'x-hasura-admin-secret': 'aUCyUfhw8eNxR35se7IzQ4D1yEQvB8vu',
        'x-hasura-user-id': uid,
      },
    );
    return (GraphQLClient(
      link: httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ));
  }

  static HttpLink httpLink = HttpLink(
    uri: 'https://tryme-backend.herokuapp.com/v1/graphql',
    headers: <String, String>{
      'x-hasura-admin-secret': 'aUCyUfhw8eNxR35se7IzQ4D1yEQvB8vu',
    },
  );

  /*AuthLink authLink = AuthLink(
      //getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
      getToken: () => 'Bearer <aUCyUfhw8eNxR35se7IzQ4D1yEQvB8vu>',
    );
    Link link = authLink.concat(httpLink);*/
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: NormalizedInMemoryCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
    ),
  );

  GraphQLClient clientToQuery = GraphQLClient(
    link: httpLink,
    cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
  );
}
