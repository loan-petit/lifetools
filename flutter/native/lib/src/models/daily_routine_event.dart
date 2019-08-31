import 'package:flutter/material.dart';

import 'package:flutter_app/src/models/user.dart';

/// Abstraction of a daily routine event. This class should be build from
/// GraphQL API responses returning a DailyRoutineEvent.
///
/// An event is identified by his [id] (unique) and name.
///
/// The temporality of daily routine events is a day. That's why the
/// [startTime] and [endTime] should be defined in seconds in term of daytime.
/// Each event can either have a duration or be a event isolated in time.
/// For an event with a duration, [endTime] has to be greater that [startTime].
/// For an event isolated in time, [startTime] has to be equal to [endTime].
///
/// Each event is integrated in the daily routine of a user, his [owner].
class DailyRoutineEventModel {
  String id;
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  UserModel owner;

  DailyRoutineEventModel({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.owner,
  });

  /// Build this model from the JSON responses of the GraphQL API.
  factory DailyRoutineEventModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return DailyRoutineEventModel();
    }

    return DailyRoutineEventModel(
      id: json['id'],
      name: json['name'],
      startTime: (json['startTime'] != null)
          ? TimeOfDay.fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(
                json['startTime'] * 1000,
              ),
            )
          : null,
      endTime: (json['endTime'] != null)
          ? TimeOfDay.fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(
                json['endTime'] * 1000,
              ),
            )
          : null,
      owner: UserModel.fromJson(json['owner']),
    );
  }
}
