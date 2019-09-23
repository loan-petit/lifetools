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
    String args = _graphQLHelper.mapToParams(credentials);
    String body = """
      mutation SignIn {
        signin $args {
          token
          expiresIn
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isMutation: true);

    return UserModel.fromJson(responseBody['signin']);
  }

  /// Sign a user up based on his [credentials].
  Future<UserModel> signUp(Map<String, String> credentials) async {
    String args = _graphQLHelper.mapToParams(credentials);
    String body = """
      mutation SignUp {
        signup $args {
          token
          expiresIn
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isMutation: true);

    return UserModel.fromJson(responseBody['signup']);
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
          }
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isQuery: true);

    return UserModel.fromJson(responseBody['me']);
  }
}
