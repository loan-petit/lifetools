import 'dart:async';

import 'package:graphql/client.dart';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/resources/user_provider.dart';
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
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<Iterable<GoalModel>> fetchMany(
    Map<String, dynamic> query, {
    bool updateCache = false,
  }) async {
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      query FetchGoals {
        goals $args {
          id
          name
          date
          isCompleted
        }
      }
    """;

    Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      isQuery: true,
      updateCache: updateCache,
    );

    return result['goals'].map<GoalModel>((goal) => GoalModel.fromJson(goal));
  }

  /// Fetch a goal based on the provided [query] parameters.
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<GoalModel> fetchOne(
    Map<String, dynamic> query, {
    bool updateCache = false,
  }) async {
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      query FetchGoal {
        goal $args {
          id
          name
          date
          isCompleted
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      isQuery: true,
      updateCache: updateCache,
    );

    return GoalModel.fromJson(result['goal']);
  }

  /// Create a goal based on the provided [query] parameters.
  Future<void> createOne(Map<String, dynamic> query) async {
    final String currentUserId = (await UserProvider().getCurrentUser()).id;
    final String args = _graphQLHelper.mapToParams({
      ...query,
      'owner': {
        'connect': {'id': currentUserId}
      },
    });
    final String body = """
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
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
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
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      mutation DeleteOneGoal {
        deleteOneGoal $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }
}
