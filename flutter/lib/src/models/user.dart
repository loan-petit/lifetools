import 'package:lifetools/src/models/daily_routine_event.dart';

/// Abstraction of a user. This class should be build from GraphQL API
/// responses returning an AuthPayload.
///
/// A user is identified by his unique [id].
///
/// A user has to use his username (unique) and password to log him in.
/// For security and privacy reasons neither of thoses are stored.
///
/// When a user is logged in a [token] (JWT) is given to him
/// with an [expiresIn] time.
class UserModel {
  String id;
  String token;
  int expiresIn;
  List<DailyRoutineEventModel> dailyRoutine;

  UserModel({
    this.id,
    this.token,
    this.expiresIn,
    this.dailyRoutine,
  });

  /// Build this model from the JSON responses of the GraphQL API.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return UserModel();
    }

    if (json['user'] != null) {
      return UserModel(
        token: json['token'],
        expiresIn: json['expiresIn'],
        id: json['user']['id'],
        dailyRoutine: json['user']['dailyRoutine']?.map<DailyRoutineEventModel>(
            (event) => DailyRoutineEventModel.fromJson(event)),
      );
    }

    return UserModel(
      token: json['token'],
      expiresIn: json['expiresIn'],
    );
  }
}
