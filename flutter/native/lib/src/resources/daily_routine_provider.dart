import 'dart:async';

import 'package:flutter_app/src/models/daily_routine_item.dart';
import 'package:flutter_app/src/services/data_persistence_service.dart';
import 'package:flutter_app/src/utils/graphql/graphql_helper.dart';

/// Provide CRUD operations, on GraphQL API, related to the daily routine
/// and its items.
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the resolvers and their parameters.
class DailyRoutineProvider {
  /// Service used to access the JWT of the logged in user.
  final _dataPersistenceService = DataPersistenceService();

  /// Authorization header providing access to GraphQL resolvers
  /// requesting authentication.
  Map<String, String> get _authorizationHeader => {
        'Authorization': 'Bearer ${_dataPersistenceService.get('id_token')}',
      };

  /// Fetch the daily routine of the logged in user.
  Future<Iterable<DailyRoutineItemModel>> fetch() async {
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

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'me',
    );

    return responseBody['user']['dailyRoutine'].map<DailyRoutineItemModel>(
        (mediaList) => DailyRoutineItemModel.fromJson(mediaList));
  }

  /// Fetch a daily routine item based on the provided [query] parameters.
  Future<DailyRoutineItemModel> fetchOneItem(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      query FetchOneDailyRoutineItem{
        findOneDailyRoutineItem $args {
          id
          name
          startTime
          endTime
        }
      }
    """;

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'findOneDailyRoutineItem',
    );

    return DailyRoutineItemModel.fromJson(responseBody);
  }

  /// Create a daily routine item based on the provided [query] parameters.
  Future<void> createOneItem(Map<String, String> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation CreateOneDailyRoutineItem {
        createOneDailyRoutineItem $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'createOneDailyRoutineItem',
    );
  }

  /// Update a daily routine item based on the provided [query] parameters.
  Future<void> updateOneItem(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation UpdateOneDailyRoutineItem {
        updateOneDailyRoutineItem $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'updateOneDailyRoutineItem',
    );
  }

  /// Delete a daily routine item based on the provided [query] parameters.
  Future<void> deleteOneItem(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation DeleteOneDailyRoutineItem {
        deleteOneDailyRoutineItem $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'deleteOneDailyRoutineItem',
    );
  }
}
