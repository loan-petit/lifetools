import 'package:meta/meta.dart';

import 'package:graphql/client.dart';

import 'package:lifetools/src/environment.dart';
import 'package:lifetools/src/services/data_persistence_service.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Helper for the GraphQLClient and for the GraphQL API.
///
/// This class is a Singleton.
class GraphQLHelper {
  static final GraphQLHelper _singleton = GraphQLHelper._internal();

  /// [HttpLink] to the GraphQL API endpoint.
  final HttpLink _httpLink = HttpLink(
    uri: Environment.vars['apiEndpoint'],
  );

  Link get _link {
    // Authorization header providing access to GraphQL resolvers
    // requesting authentication.
    final AuthLink _authLink = AuthLink(
      getToken: () async =>
          'Bearer ${DataPersistenceService().get('jwt_token')}',
    );

    return _authLink.concat(_httpLink);
  }

  /// Client needed to interact with the GraphQL API.
  GraphQLClient _client;

  final OptimisticCache cache = OptimisticCache(
    dataIdFromObject: typenameDataIdFromObject,
  );

  factory GraphQLHelper() {
    return _singleton;
  }

  GraphQLHelper._internal();

  /// Initialize a new [GraphQLClient].
  void init() {
    _client = GraphQLClient(
      link: _link,
      cache: cache,
    );
  }

  /// Send a request to the GraphQL API, treat errors and return the data.
  ///
  /// The [body] will be used as [QueryOptions.document] and
  /// [MutationOptions.document] depending on the [isQuery] and
  /// [isMutation] values.
  ///
  /// If some objects have been created or removed from the database,
  /// you may want to update the cache of related queries. To do this,
  /// set [updateCache] to true.
  Future<Map<String, dynamic>> request({
    @required String body,
    Map<String, dynamic> variables,
    bool isQuery = false,
    bool isMutation = false,
    bool updateCache = false,
  }) async {
    assert(isQuery == true || isMutation == true);
    assert(body != null);

    QueryResult result;
    if (isQuery) {
      final QueryOptions options = QueryOptions(
        document: body,
        fetchPolicy: (updateCache)
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.cacheFirst,
        variables: variables,
      );
      result = await _client.query(options);
    } else if (isMutation) {
      final MutationOptions options = MutationOptions(
        document: body,
        fetchPolicy: (updateCache)
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.cacheFirst,
        variables: variables,
      );
      result = await _client.mutate(options);
    }

    if (result.hasErrors) {
      throw GraphQLException(
        message: "An error occured during a request to the GraphQL backend.",
        errors: result.errors,
      );
    }

    return result.data;
  }
}
