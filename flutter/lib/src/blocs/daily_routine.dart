import 'package:rxdart/rxdart.dart';

import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/resources/daily_routine_provider.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the daily routine and its events.
class DailyRoutineBloc {
  /// Provider of the daily routine related requests, responsible
  /// of making API calls.
  final DailyRoutineProvider _dailyRoutineProvider = DailyRoutineProvider();

  /// Sink and Streams controller for the daily routine.
  final PublishSubject<Iterable<DailyRoutineEventModel>> _dailyRoutineSubject =
      PublishSubject<Iterable<DailyRoutineEventModel>>();

  /// Stream of daily routine.
  Observable<Iterable<DailyRoutineEventModel>> get dailyRoutine =>
      _dailyRoutineSubject.stream;

  /// Sink and Streams controller for the daily routine events.
  final PublishSubject<DailyRoutineEventModel> _dailyRoutineEventSubject =
      PublishSubject<DailyRoutineEventModel>();

  /// Stream of daily routine event.
  Observable<DailyRoutineEventModel> get event =>
      _dailyRoutineEventSubject.stream;

  /// Dispose of every [PublishSubject] to close all open streams.
  dispose() {
    _dailyRoutineSubject.close();
    _dailyRoutineEventSubject.close();
  }

  /// Fetch the daily routine of the logged in user and add it to
  /// the [_dailyRoutineSubject.sink].
  ///
  /// Specify the [userId] of a user to retrieve its daily routine.
  /// If you want to retrieve the daily routine of the logged in user,
  /// you should instead set [fromCurrentUser] to true.
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<void> fetch({
    String userId,
    bool fromCurrentUser = false,
    bool updateCache = false,
  }) async {
    try {
      Iterable<DailyRoutineEventModel> dailyRoutine =
          await _dailyRoutineProvider.fetch(
        userId: userId,
        fromCurrentUser: fromCurrentUser,
        updateCache: updateCache,
      );
      _dailyRoutineSubject.sink.add(dailyRoutine);
    } on GraphQLException catch (e) {
      _dailyRoutineSubject.sink.addError(e);
    }
  }

  /// Fetch a daily routine event and add it to
  /// the [_dailyRoutineEventSubject.sink].
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'findOneDailyRoutineEvent' resolver.
  ///
  /// If some events have been created or removed from the database,
  /// you may want to update the cache. To do this, set [updateCache] to true.
  Future<void> fetchOneEvent(
    Map<String, dynamic> query, {
    bool updateCache = false,
  }) async {
    try {
      DailyRoutineEventModel dailyRoutineEvent =
          await _dailyRoutineProvider.fetchOneEvent(
        query,
        updateCache: updateCache,
      );
      _dailyRoutineEventSubject.sink.add(dailyRoutineEvent);
    } on GraphQLException catch (e) {
      _dailyRoutineEventSubject.sink.addError(e);
    }
  }

  /// Create a daily routine event.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'createOneDailyRoutineEvent' resolver.
  Future<void> createOneEvent(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.createOneEvent(query);
  }

  /// Update a daily routine event.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'updateOneDailyRoutineEvent' resolver.
  Future<void> updateOneEvent(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.updateOneEvent(query);
  }

  /// Delete a daily routine event.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'deleteOneDailyRoutineEvent' resolver.
  Future<void> deleteOneEvent(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.deleteOneEvent(query);
  }
}
