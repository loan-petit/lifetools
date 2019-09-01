import 'dart:convert';

import 'package:flutter_web/material.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_app/src/environment.dart';
import 'package:flutter_app/src/utils/graphql/graphql_exception.dart';

class GraphqlHelper {
  /// Content-Type header necessary to any GraphQL request.
  static Map<String, String> get contentTypeHeader =>
      {'Content-Type': 'application/graphql'};

  /// Convert the [map] to GraphQL resolver paramenters.
  static String mapToParams(Map<String, dynamic> map) {
    if (map.isEmpty) {
      return '';
    }

    String args = json.encode(map);

    args = args.replaceRange(0, 1, '(');
    args = args.replaceRange(args.length - 1, args.length, ')');
    args = args.replaceAllMapped(
      RegExp(r'"([^"]*?)":'),
      (Match m) => "${m[1]}:",
    );
    return args;
  }

  /// Send a request to the GraphQL API, treat errors and return the data.
  ///
  /// The [body] and [headers] will respectively be the headers of the request.
  ///
  /// The [resolverName] is the name of the resolver called.
  /// This property is used to retrieve data from the response.
  static Future<dynamic> request({
    @required String body,
    Map<String, String> headers = const {},
    @required String resolverName,
  }) async {
    final http.Response response = await http.post(
      Environment.vars['apiEndpoint'],
      body: body,
      headers: {
        ...contentTypeHeader,
        ...headers,
      },
    );

    Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode != 200 || doesErrorOccured(responseBody)) {
      throw GraphqlException.fromJson(responseBody);
    }
    return responseBody['data'][resolverName];
  }

  /// Check if an error occured during the request based on its [json] response.
  static doesErrorOccured(Map<String, dynamic> json) =>
      json['error'] != null || json['errors'] != null;
}
