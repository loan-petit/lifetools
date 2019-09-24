import 'package:rxdart/rxdart.dart';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/resources/goal_provider.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the daily goals.
class GoalBloc {
  /// Provider of the goal related requests, responsible of making API calls.
  final GoalProvider _goalProvider = GoalProvider();

  /// Sink and Streams controller for a goal.
  final PublishSubject<GoalModel> _goalSubject = PublishSubject<GoalModel>();

  /// Stream of goal.
  Observable<GoalModel> get goal => _goalSubject.stream;

  /// Sink and Streams controller for multiple goals.
  final PublishSubject<Iterable<GoalModel>> _goalsSubject =
      PublishSubject<Iterable<GoalModel>>();

  /// Stream of multiple goals.
  Observable<Iterable<GoalModel>> get goals => _goalsSubject.stream;

  /// Dispose of every [PublishSubject] to close all open streams.
  dispose() {
    _goalSubject.close();
    _goalsSubject.close();
  }

  /// Fetch multiples goals of a user and add it to
  /// the [_goalsSubject.sink].
  ///
  /// Specify the [ownerId] of a user to retrieve his goals.
  /// If you want to retrieve the goals of the logged in user,
  /// you should instead set [fromCurrentUser] to true.
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<void> fetchMany({
    String ownerId,
    bool fromCurrentUser = false,
    bool updateCache = false,
  }) async {
    try {
      Iterable<GoalModel> goals = await _goalProvider.fetchMany(
        ownerId: ownerId,
        fromCurrentUser: fromCurrentUser,
        updateCache: updateCache,
      );
      _goalsSubject.sink.add(goals);
    } on GraphQLException catch (e) {
      _goalsSubject.sink.addError(e);
    }
  }

  /// Fetch a goal matching the provided [id] and add it to
  /// the [_dailyRoutineEventSubject.sink].
  ///
  /// If some goals have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<void> fetchOne(
    String id, {
    bool updateCache = false,
  }) async {
    try {
      GoalModel goal = await _goalProvider.fetchOne(
        id,
        updateCache: updateCache,
      );
      _goalSubject.sink.add(goal);
    } on GraphQLException catch (e) {
      _goalSubject.sink.addError(e);
    }
  }

  /// Create a goal.
  ///
  /// The [data] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'createOneGoal' resolver's data of
  /// type GoalCreateInput.
  Future<void> createOne(Map<String, dynamic> data) async {
    await _goalProvider.createOne(data);
  }

  /// Update a goal whose ID matches [whereId].
  ///
  /// The [data] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'updateOneGoal' resolver's
  /// data of type GoalUpdateInput.
  Future<void> updateOne(String whereId, Map<String, dynamic> data) async {
    await _goalProvider.updateOne(whereId, data);
  }

  /// Delete a goal matching the provided [id].
  Future<void> deleteOne(String id) async {
    await _goalProvider.deleteOne(id);
  }
}
