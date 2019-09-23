import 'package:rxdart/rxdart.dart';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/resources/goal_provider.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the daily goals.
class GoalBloc {
  /// Provider of the goal related requests, responsible of making API calls.
  final GoalProvider _goalProvider = GoalProvider();

  /// Sink and Streams controller for a goal.
  final PublishSubject<GoalModel> _goalSubject =
      PublishSubject<GoalModel>();

  /// Stream of goal.
  Observable<GoalModel> get goal =>
      _goalSubject.stream;

  /// Sink and Streams controller for multiple goals.
  final PublishSubject<Iterable<GoalModel>> _goalsSubject =
      PublishSubject<Iterable<GoalModel>>();

  /// Stream of multiple goals.
  Observable<Iterable<GoalModel>> get goals =>
      _goalsSubject.stream;

  /// Dispose of every [PublishSubject] to close all open streams.
  dispose() {
    _goalSubject.close();
    _goalsSubject.close();
  }

  /// Fetch multiples goals of a user and add it to
  /// the [_goalsSubject.sink].
  /// 
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'goals' resolver.
  Future<void> fetchMany(Map<String, dynamic> query) async {
    try {
      Iterable<GoalModel> goals =
          await _goalProvider.fetchMany(query);
      _goalsSubject.sink.add(goals);
    } on GraphqlException catch (e) {
      _goalsSubject.sink.addError(e);
    }
  }

  /// Fetch a goal and add it to the [_goalSubject.sink].
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'goal' resolver.
  Future<void> fetchOne(Map<String, dynamic> query) async {
    try {
      GoalModel goal =
          await _goalProvider.fetchOne(query);
      _goalSubject.sink.add(goal);
    } on GraphqlException catch (e) {
      _goalSubject.sink.addError(e);
    }
  }

  /// Create a new goal.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'createOneGoal' resolver.
  Future<void> createOne(Map<String, dynamic> query) async {
    await _goalProvider.createOne(query);
  }

  /// Update a goal.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'updateOneGoal' resolver.
  Future<void> updateOne(Map<String, dynamic> query) async {
    await _goalProvider.updateOne(query);
  }

  /// Delete a goal.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'deleteOneGoal' resolver.
  Future<void> deleteOne(Map<String, dynamic> query) async {
    await _goalProvider.deleteOne(query);
  }
}
