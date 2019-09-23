import 'package:graphql/client.dart';
import 'package:lifetools/src/environment.dart';

/// [Exception] raised on error for HTTP request to GraphQL API.
class GraphQLException implements Exception {
  final String message;
  final List<GraphQLError> errors;

  GraphQLException({this.message, this.errors})
      : assert(message != null),
        assert(errors != null) {
    if (Environment.env == EnvironmentType.DEV) {
      print(errors);
    }
  }
}
