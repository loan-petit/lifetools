import 'package:rxdart/rxdart.dart';

import 'package:flutter_app/src/models/daily_routine_item.dart';
import 'package:flutter_app/src/resources/daily_routine_provider.dart';
import 'package:flutter_app/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the daily routine of a user.
class DailyRoutineBloc {
  /// Provider of the authentication requests, responsible of making API calls.
  final DailyRoutineProvider _dailyRoutineProvider = DailyRoutineProvider();

  /// Sink and Streams controller for the daily routine.
  final PublishSubject<Iterable<DailyRoutineItemModel>> _dailyRoutineSubject =
      PublishSubject<Iterable<DailyRoutineItemModel>>();

  /// Stream of daily routine.
  Observable<Iterable<DailyRoutineItemModel>> get dailyRoutine =>
      _dailyRoutineSubject.stream;

  /// Sink and Streams controller for the daily routine items.
  final PublishSubject<DailyRoutineItemModel> _dailyRoutineItemSubject =
      PublishSubject<DailyRoutineItemModel>();

  /// Stream of daily routine item.
  Observable<DailyRoutineItemModel> get item => _dailyRoutineItemSubject.stream;

  /// Dispose of the the [_usersSubject] to close all open streams.
  dispose() {
    _dailyRoutineSubject.close();
    _dailyRoutineItemSubject.close();
  }

  /// Fetch the daily routine of the logged in user and add it to
  /// the [_dailyRoutineSubject.sink].
  Future<void> fetch() async {
    try {
      Iterable<DailyRoutineItemModel> dailyRoutine =
          await _dailyRoutineProvider.fetch();
      _dailyRoutineSubject.sink.add(dailyRoutine);
    } on GraphqlException catch (e) {
      _dailyRoutineSubject.sink.addError(e);
    }
  }

  /// Fetch a daily routine item and add it to
  /// the [_dailyRoutineItemSubject.sink].
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'findOneDailyRoutineItem' resolver.
  Future<void> fetchOneItem(Map<String, dynamic> query) async {
    try {
      DailyRoutineItemModel dailyRoutineItem =
          await _dailyRoutineProvider.fetchOneItem(query);
      _dailyRoutineItemSubject.sink.add(dailyRoutineItem);
    } on GraphqlException catch (e) {
      _dailyRoutineItemSubject.sink.addError(e);
    }
  }

  /// Create a daily routine item.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'createOneDailyRoutineItem' resolver.
  Future<void> create(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.createOneItem(query);
  }

  /// Create a daily routine item.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'updateOneDailyRoutineItem' resolver.
  Future<void> update(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.updateOneItem(query);
  }

  /// Create a daily routine item.
  ///
  /// The [query] key and values must match the JSON key and values needed
  /// by the GraphQL API for the 'deleteOneDailyRoutineItem' resolver.
  Future<void> delete(Map<String, dynamic> query) async {
    await _dailyRoutineProvider.deleteOneItem(query);
  }
}
