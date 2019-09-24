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
  /// Specify the [userId] of a user to retrieve its daily routine.
  /// If you want to retrieve the daily routine of the logged in user,
  /// you should instead set [fromCurrentUser] to true.
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<Iterable<DailyRoutineEventModel>> fetch({
    String userId,
    bool fromCurrentUser = false,
    bool updateCache = false,
  }) async {
    assert(userId != null || fromCurrentUser == true);

    List<dynamic> dailyRoutine;

    if (userId != null) {
      // Retrieve the daily routine of a specific user.
      final String body = """
        query FetchDailyRoutine {
          user (id: $userId) {
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
      dailyRoutine = (await _graphQLHelper.request(
        body: body,
        isQuery: true,
        updateCache: updateCache,
      ))['user']['dailyRoutine'];
    } else if (fromCurrentUser == true) {
      // Retrieve the daily routine of the logged in user.
      final String body = """
        query FetchDailyRoutine {
          me {
            user {
              dailyRoutine {
                __typename
                id
                name
                startTime
                endTime
              }
            }
          }
        }
      """;
      dailyRoutine = (await _graphQLHelper.request(
        body: body,
        isQuery: true,
        updateCache: updateCache,
      ))['me']['user']['dailyRoutine'];
    }

    return dailyRoutine.map<DailyRoutineEventModel>(
        (event) => DailyRoutineEventModel.fromJson(event));
  }

  /// Fetch a daily routine event based on the provided [query] parameters.
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<DailyRoutineEventModel> fetchOneEvent(
    Map<String, dynamic> query, {
    bool updateCache = false,
  }) async {
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      query FetchDailyRoutineEvent {
        dailyroutineevent $args {
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
      isQuery: true,
      updateCache: updateCache,
    );

    return DailyRoutineEventModel.fromJson(result['dailyroutineevent']);
  }

  /// Create a daily routine event based on the provided [query] parameters.
  Future<void> createOneEvent(Map<String, dynamic> query) async {
    final String currentUserId = (await UserProvider().getCurrentUser()).id;
    final String args = _graphQLHelper.mapToParams({
      ...query,
      'data': {
        ...query['data'],
        'owner': {
          'connect': {'id': currentUserId}
        },
      }
    });
    final String body = """
      mutation CreateOneDailyRoutineEvent {
        createOneDailyRoutineEvent $args {
          __typename
          id
          name
          startTime
          endTime
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Update a daily routine event based on the provided [query] parameters.
  Future<void> updateOneEvent(Map<String, dynamic> query) async {
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      mutation UpdateOneDailyRoutineEvent {
        updateOneDailyRoutineEvent $args {
          __typename
          id
          name
          startTime
          endTime
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Delete a daily routine event based on the provided [query] parameters.
  Future<void> deleteOneEvent(Map<String, dynamic> query) async {
    final String args = _graphQLHelper.mapToParams(query);
    final String body = """
      mutation DeleteOneDailyRoutineEvent {
        deleteOneDailyRoutineEvent $args {
          __typename
          id
          name
          startTime
          endTime
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }
}
