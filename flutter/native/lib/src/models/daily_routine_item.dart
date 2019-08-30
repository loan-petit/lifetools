import 'package:flutter_app/src/models/user.dart';

/// Abstraction of a daily routine item. This class should be build from
/// GraphQL API responses returning a DailyRoutineItem.
///
/// An item is identified by his [id] (unique) and name.
///
/// The temporality of daily routine events is a day. That's why the
/// [startTime] and [endTime] should be defined in seconds in term of daytime.
/// Each item can either have a duration or be a event isolated in time.
/// For an event with a duration, [endTime] has to be greater that [startTime].
/// For an event isolated in time, [startTime] has to be equal to [endTime].
///
/// Each item is integrated in the daily routine of a user, his [owner].
class DailyRoutineItemModel {
  String id;
  String name;
  int startTime;
  int endTime;
  UserModel owner;

  DailyRoutineItemModel({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.owner,
  });

  /// Build this model from the JSON responses of the GraphQL API.
  factory DailyRoutineItemModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return DailyRoutineItemModel();
    }

    return DailyRoutineItemModel(
      id: json['id'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      owner: UserModel.fromJson(json['owner']),
    );
  }
}
