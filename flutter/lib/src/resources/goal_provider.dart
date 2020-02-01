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

  /// Fetch multiple goals based on the provided [variables] parameters.
  ///
  /// Specify the [userId] of a user to retrieve his goals.
  /// If you want to retrieve the goals of the logged in user,
  /// you should instead set [fromCurrentUser] to true.
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<Iterable<GoalModel>> fetchMany({
    String ownerId,
    bool fromCurrentUser = false,
    bool updateCache = false,
  }) async {
    assert(ownerId != null || fromCurrentUser == true);

    if (fromCurrentUser == true) {
      ownerId = (await UserProvider().getCurrentUser()).id;
    }

    final String body = """
      query FetchGoals(\$ownerId: String!) {
        user(where: { id: \$ownerId }) {
          goals {
            __typename
            id
            name
            date
            isCompleted
          }
        }
      }
    """;

    Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      variables: {'ownerId': ownerId},
      isQuery: true,
      updateCache: updateCache,
    );

    return result['user']['goals']
        .map<GoalModel>((goal) => GoalModel.fromJson(goal));
  }

  /// Fetch a goal matching the provided [id].
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<GoalModel> fetchOne(
    String id, {
    bool updateCache = false,
  }) async {
    final String body = """
      query Goal(\$id: String!) {
        goal(id: \$id) {
          __typename
          id
          name
          date
          isCompleted
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      variables: {'id': id},
      isQuery: true,
      updateCache: updateCache,
    );

    return GoalModel.fromJson(result['goal']);
  }

  /// Create a goal based on the provided [data].
  Future<void> createOne(Map<String, dynamic> data) async {
    final String currentUserId = (await UserProvider().getCurrentUser()).id;
    final String body = """
      mutation CreateOneGoal(
        \$name: String!
        \$date: DateTime!
        \$ownerId: String!
      ) {
        createOneGoal(
          data: {
            name: \$name
            date: \$date
            owner: {
              connect: { id: \$ownerId }
            }
          }
        ) {
          __typename
          id
          name
          date
          isCompleted
        }
      }
    """;

    await _graphQLHelper.request(
      body: body,
      variables: {...data, 'ownerId': currentUserId},
      isMutation: true,
    );
  }

  /// Update a goal whose ID matches [whereId].
  ///
  /// The goal data will be updated based on the provided [data].
  Future<void> updateOne(String whereId, Map<String, dynamic> data) async {
    final String body = """
      mutation UpdateOneGoal(
        \$whereId: String!
        \$name: String
        \$date: DateTime
        \$isCompleted: Boolean
      ) {
        updateOneGoal(
          where: {
            id: \$whereId
          }
          data: {
            name: \$name
            date: \$date
            isCompleted: \$isCompleted
          }
        ) {
          __typename
          id
          name
          date
          isCompleted
        }
      }
    """;

    await _graphQLHelper.request(
      body: body,
      variables: {'whereId': whereId, ...data},
      isMutation: true,
      updateCache: true,
    );
  }

  /// Delete a goal matching the provided [id].
  Future<void> deleteOne(String id) async {
    final String body = """
      mutation DeleteOneGoal(
        \$id: String!
      ) {
        deleteOneGoal(
          where: {
            id: \$id
          }
        ) {
          __typename
          id
          name
          date
          isCompleted
        }
      }
    """;

    await _graphQLHelper.request(
      body: body,
      variables: {'id': id},
      isMutation: true,
    );
  }
}
