import 'package:rxdart/rxdart.dart';

import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/resources/daily_routine_provider.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the daily routine and its events.
class DailyRoutineBloc {
  /// Provider of the authentication requests, responsible of making API calls.
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

  /// Dispose of the the [_usersSubject] to close all open streams.
  dispose() {
    _dailyRoutineSubject.close();
    _dailyRoutineEventSubject.close();
  }

  /// Fetch the daily routine of the logged in user and add it to
  /// the [_dailyRoutineSubject.sink].
  Future<void> fetch() async {
    try {
      Iterable<DailyRoutineEventModel> dailyRoutine =
          await _dailyRoutineProvider.fetch();
      _dailyRoutineSubject.sink.add(dailyRoutine);
    } on GraphqlException catch (e) {
      _dailyRoutineSubject.sink.addError(e);
    }
  }

  /// Fetch a daily routine event and add it to
  /// the [_dailyRoutineEventSubject.sink].
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'findOneDailyRoutineEvent' resolver.
  Future<void> fetchOneEvent(Map<String, dynamic> query) async {
    try {
      DailyRoutineEventModel dailyRoutineEvent =
          await _dailyRoutineProvider.fetchOneEvent(query);
      _dailyRoutineEventSubject.sink.add(dailyRoutineEvent);
    } on GraphqlException catch (e) {
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

  /// Create a daily routine event.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'updateOneDailyRoutineEvent' resolver.
  Future<void> updateOneEvent(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.updateOneEvent(query);
  }

  /// Create a daily routine event.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'deleteOneDailyRoutineEvent' resolver.
  Future<void> deleteOneEvent(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.deleteOneEvent(query);
  }
}
