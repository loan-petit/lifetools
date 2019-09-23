import 'dart:async';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/services/data_persistence_service/index.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

/// Provide CRUD operations, on GraphQL API, related to the goals.
///
/// Check out the GraphQL API documentation to get a deeper understanding
/// of the resolvers and their parameters.
class GoalProvider {
  /// Service used to access the JWT of the logged in user.
  final _dataPersistenceService = DataPersistenceService();

  /// Authorization header providing access to GraphQL resolvers
  /// requesting authentication.
  Map<String, String> get _authorizationHeader => {
        'Authorization': 'Bearer ${_dataPersistenceService.get('id_token')}',
      };

  /// Fetch multiple goals based on the provided [query] parameters.
  Future<Iterable<GoalModel>> fetchMany(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
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

    List<Map<String, dynamic>> responseBody = await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'goals',
    );

    return responseBody.map<GoalModel>((goal) => GoalModel.fromJson(goal));
  }

  /// Fetch a goal based on the provided [query] parameters.
  Future<GoalModel> fetchOne(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
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

    Map<String, dynamic> responseBody = await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'goal',
    );

    return GoalModel.fromJson(responseBody);
  }

  /// Create a goal based on the provided [query] parameters.
  Future<void> createOne(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation CreateOneGoal {
        createOneGoal $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'createOneGoal',
    );
  }

  /// Update a goal based on the provided [query] parameters.
  Future<void> updateOne(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation UpdateOneGoal {
        updateOneGoal $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'updateOneGoal',
    );
  }

  /// Delete a goal based on the provided [query] parameters.
  Future<void> deleteOne(Map<String, dynamic> query) async {
    String args = GraphqlHelper.mapToParams(query);
    String body = """
      mutation DeleteOneGoal {
        deleteOneGoal $args {
          id
        }
      }
    """;

    await GraphqlHelper.request(
      body: body,
      headers: _authorizationHeader,
      resolverName: 'deleteOneGoal',
    );
  }
}
