import 'dart:async';

import 'package:flutter_app/src/models/user.dart';
import 'package:flutter_app/src/services/data_persistence_service.dart';
import 'package:flutter_app/src/utils/graphql/graphql_helper.dart';

/// Provide user related data from the GraphQL API and store it in [UserModel].
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the queries and their parameters.
class UserProvider {
  /// Service used to persist user's authentication token.
  final _dataPersistenceService = DataPersistenceService();

  /// Authorization header providing access to GraphQL resolvers
  /// requesting authentication.
  Map<String, String> get _authorizationHeader =>
      {'Authorization': 'Bearer ${_dataPersistenceService.get('id_token')}'};

  /// Sign a user in based on his [credentials].
  Future<UserModel> signIn(Map<String, String> credentials) async {
    String args = GraphqlHelper.mapToParams(credentials);
    String body = """
      mutation SignIn {
        signin $args {
          token
          expiresIn
        }
      }
    """;

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      resolverName: 'signin',
    );
    return UserModel.fromJson(responseBody);
  }

  /// Sign a user up based on his [credentials].
  Future<UserModel> signUp(Map<String, String> credentials) async {
    String args = GraphqlHelper.mapToParams(credentials);
    String body = """
      mutation SignUp {
        signup $args {
          token
          expiresIn
        }
      }
    """;

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      resolverName: 'signup',
    );
    return UserModel.fromJson(responseBody);
  }

  /// Get the user whose JSON Web Token is send in Authorization header.
  /// This user is the logged in one.
  Future<UserModel> getCurrentUser() async {
    String body = """
      query GetUserFromToken {
        me {
          token
          expiresIn
          user {
            id
            firstName
            lastName
            title
            description
          }
        }
      }
    """;

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'me',
    );
    return UserModel.fromJson(responseBody);
  }
}
