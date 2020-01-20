import 'dart:async';

import 'package:lifetools/src/models/user.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

/// Provide CRUD operations, on GraphQL API, related to the users.
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the resolvers and their parameters.
class UserProvider {
  /// Abstract interactions with the [GraphQLClient] and requests to the
  /// GraphQL API.
  GraphQLHelper _graphQLHelper = GraphQLHelper();

  /// Sign a user in based on his [credentials].
  Future<UserModel> signIn(Map<String, String> credentials) async {
    final String body = """
      mutation SignIn(\$username: String!, \$password: String!) {
        signin(username: \$username, password: \$password) {
          token
          expiresIn
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      variables: credentials,
      isMutation: true,
    );

    return UserModel.fromJson(result['signin']);
  }

  /// Sign a user up based on his [credentials].
  Future<UserModel> signUp(Map<String, String> credentials) async {
    final String body = """
      mutation SignUp(
        \$username: String!
        \$password: String!
        \$passwordConfirmation: String!
      ) {
        signup(
          username: \$username
          password: \$password
          passwordConfirmation: \$passwordConfirmation
        ) {
          token
          expiresIn
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      variables: credentials,
      isMutation: true,
    );

    return UserModel.fromJson(result['signup']);
  }

  /// Get the user whose JSON Web Token is send in Authorization header.
  /// This user is the logged in one.
  ///
  /// If the user has changed since the last log in, you may want to update
  /// the cache. To do this, set [updateCache] to true.
  Future<UserModel> getCurrentUser({
    bool updateCache = false,
  }) async {
    final String body = """
      query GetUserFromJwt {
        me {
          token
          expiresIn
          user {
            __typename
            id
          }
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      isQuery: true,
      updateCache: updateCache,
    );

    return UserModel.fromJson(result['me']);
  }
}
