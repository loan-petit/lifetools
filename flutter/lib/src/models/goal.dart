import 'package:lifetools/src/models/user.dart';

/// Abstraction of a goal. This class should be build from
/// GraphQL API responses returning a Goal.
///
/// A goal is identified by his [id] (unique) and name.
///
/// The goal owner can set it completed using [isCompleted].
/// 
/// A goal can only be assigned to one day. This day is specified in [date].
///
/// Each goal is assigned to a user, his [owner].
class GoalModel {
  String id;
  String name;
  DateTime date;
  bool isCompleted;
  UserModel owner;

  GoalModel({
    this.id,
    this.name,
    this.date,
    this.isCompleted,
    this.owner,
  });

  /// Build this model from the JSON responses of the GraphQL API.
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return GoalModel();
    }

    return GoalModel(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']).toLocal(),
      isCompleted: json['isCompleted'],
      owner: UserModel.fromJson(json['owner']),
    );
  }
}
