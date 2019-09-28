import 'dart:async';

import 'package:graphql/client.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/resources/user_provider.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

/// Provide CRUD operations, on GraphQL API, related to the daily routine
/// and its events.
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the resolvers and their parameters.
class DailyRoutineProvider {
  /// Abstract interactions with the [GraphQLClient] and requests to the
  /// GraphQL API.
  GraphQLHelper _graphQLHelper = GraphQLHelper();

  /// Fetch the daily routine of a user.
  ///
  /// Specify the [userId] of a user to retrieve his daily routine.
  /// If you want to retrieve the daily routine of the logged in user,
  /// you should instead set [fromCurrentUser] to true.
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<Iterable<DailyRoutineEventModel>> fetch({
    String ownerId,
    bool fromCurrentUser = false,
    bool updateCache = false,
  }) async {
    assert(ownerId != null || fromCurrentUser == true);

    if (fromCurrentUser == true) {
      ownerId = (await UserProvider().getCurrentUser()).id;
    }

    // Retrieve the daily routine of a specific user.
    final String body = """
      query DailyRoutine(\$ownerId: ID!) {
        user(where: { id: \$ownerId }) {
          dailyRoutine {
            __typename
            id
            name
            startTime
            endTime
          }
        }
      }
    """;

    final List<dynamic> dailyRoutine = (await _graphQLHelper.request(
      body: body,
      variables: {'ownerId': ownerId},
      isQuery: true,
      updateCache: updateCache,
    ))['user']['dailyRoutine'];

    return dailyRoutine.map<DailyRoutineEventModel>(
        (event) => DailyRoutineEventModel.fromJson(event));
  }

  /// Fetch a daily routine event matching the provided [id].
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<DailyRoutineEventModel> fetchOneEvent(
    String id, {
    bool updateCache = false,
  }) async {
    final String body = """
      query DailyRoutineEvent(\$id: ID!) {
        dailyroutineevent(id: \$id) {
          __typename
          id
          name
          startTime
          endTime
        }
      }
    """;

    final Map<String, dynamic> result = await _graphQLHelper.request(
      body: body,
      variables: {'id': id},
      isQuery: true,
      updateCache: updateCache,
    );

    return DailyRoutineEventModel.fromJson(result['dailyroutineevent']);
  }

  /// Create a daily routine event based on the provided [data].
  Future<void> createOneEvent(Map<String, dynamic> data) async {
    final String currentUserId = (await UserProvider().getCurrentUser()).id;
    final String body = """
      mutation CreateOneDailyRoutineEvent(
        \$name: String!
        \$startTime: Int!
        \$endTime: Int!
        \$ownerId: ID!
      ) {
        createOneDailyRoutineEvent(
          data: {
            name: \$name
            startTime: \$startTime
            endTime: \$endTime
            owner: {
              connect: { id: \$ownerId }
            }
          }
        ) {
          __typename
          id
          name
          startTime
          endTime
        }
      }
    """;

    await _graphQLHelper.request(
      body: body,
      variables: {...data, 'ownerId': currentUserId},
      isMutation: true,
    );
  }

  /// Update a daily routine event whose ID matches [whereId].
  ///
  /// The event data will be updated based on the provided [data].
  Future<void> updateOneEvent(String whereId, Map<String, dynamic> data) async {
    final String body = """
      mutation UpdateOneDailyRoutineEvent(
        \$whereId: ID!
        \$name: String
        \$startTime: Int
        \$endTime: Int
      ) {
        updateOneDailyRoutineEvent(
          where: {
            id: \$whereId
          }
          data: {
            name: \$name
            startTime: \$startTime
            endTime: \$endTime
          }
        ) {
          __typename
          id
          name
          startTime
          endTime
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

  /// Delete a daily routine event matching the provided [id].
  Future<void> deleteOneEvent(String id) async {
    final String body = """
      mutation DeleteOneDailyRoutineEvent(
        \$id: ID!
      ) {
        deleteOneDailyRoutineEvent(
          where: {
            id: \$id
          }
        ) {
          __typename
          id
          name
          startTime
          endTime
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
