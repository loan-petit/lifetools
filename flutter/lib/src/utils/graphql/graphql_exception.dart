import 'package:lifetools/src/environment.dart';

/// [Exception] raised on error for HTTP request to backend GraphQL API.
class GraphqlException implements Exception {
  final String message;

  GraphqlException(this.message);

  /// Build this model from the [json] response of the API.
  factory GraphqlException.fromJson(Map<String, dynamic> json) {
    if (Environment.env == EnvironmentType.DEV) {
      print(json);
    }

    if (json['error'] != null) {
      if (json['error']['errors'] != null) {
        return GraphqlException(
          json['error']['errors'][0]['message'],
        );
      }
      return GraphqlException(
        json['error'],
      );
    } else if (json['errors'] != null) {
      return GraphqlException(
        json['errors'][0]['message'],
      );
    } else {
      return GraphqlException('Unexpected Error');
    }
  }
}
