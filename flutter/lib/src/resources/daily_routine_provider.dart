import 'dart:async';

import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/services/data_persistence_service/index.dart';
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

  /// Fetch the daily routine of the logged in user.
  Future<Iterable<DailyRoutineEventModel>> fetch() async {
    String body = """
      query FetchDailyRoutine {
        me {
          user {
            dailyRoutine {
              id
              name
              startTime
              endTime
            }
          }
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isQuery: true);

    return responseBody['me']['user']['dailyRoutine']
        .map<DailyRoutineEventModel>(
            (event) => DailyRoutineEventModel.fromJson(event));
  }

  /// Fetch a daily routine event based on the provided [query] parameters.
  Future<DailyRoutineEventModel> fetchOneEvent(
      Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      query FetchDailyRoutineEvent {
        dailyroutineevent $args {
          id
          name
          startTime
          endTime
        }
      }
    """;

    Map<String, dynamic> responseBody =
        await _graphQLHelper.request(body: body, isQuery: true);

    return DailyRoutineEventModel.fromJson(responseBody['dailyroutineevent']);
  }

  /// Create a daily routine event based on the provided [query] parameters.
  Future<void> createOneEvent(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation CreateOneDailyRoutineEvent {
        createOneDailyRoutineEvent $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Update a daily routine event based on the provided [query] parameters.
  Future<void> updateOneEvent(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation UpdateOneDailyRoutineEvent {
        updateOneDailyRoutineEvent $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }

  /// Delete a daily routine event based on the provided [query] parameters.
  Future<void> deleteOneEvent(Map<String, dynamic> query) async {
    String args = _graphQLHelper.mapToParams(query);
    String body = """
      mutation DeleteOneDailyRoutineEvent {
        deleteOneDailyRoutineEvent $args {
          id
        }
      }
    """;

    await _graphQLHelper.request(body: body, isMutation: true);
  }
}
