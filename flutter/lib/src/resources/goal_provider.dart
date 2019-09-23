import 'dart:async';

import 'package:graphql/client.dart';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

/// Provide CRUD operations, on GraphQL API, related to the goals.
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the resolvers and their parameters.
class GoalProvider {
  /// Abstract interactions with the [GraphQLClient] and requests to the
  /// GraphQL API.
  GraphQLHelper _graphQLHelper = GraphQLHelper();

  /// Fetch multiple goals based on the provided [query] parameters.
  Future<Iterable<GoalModel>> fetchMany(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      query FetchGoals {
        goals $args {
          id
          name
          date
          isCompleted
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isQuery: true);

    return responseBody['goals']
        .map<GoalModel>((goal) => GoalModel.fromJson(goal));
  }

  /// Fetch a goal based on the provided [query] parameters.
  Future<GoalModel> fetchOne(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      query FetchGoal {
        goal $args {
          id
          name
          date
          isCompleted
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isQuery: true);

    return GoalModel.fromJson(responseBody['goal']);
  }

  /// Create a goal based on the provided [query] parameters.
  Future<void> createOne(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation CreateOneGoal {
        createOneGoal $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Update a goal based on the provided [query] parameters.
  Future<void> updateOne(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation UpdateOneGoal {
        updateOneGoal $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Delete a goal based on the provided [query] parameters.
  Future<void> deleteOne(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation DeleteOneGoal {
        deleteOneGoal $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }
}
