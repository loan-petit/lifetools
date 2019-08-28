/// Abstraction of a user. This class should be build from GraphQL API
/// responses returning an AuthPayload.
///
/// A user is identified by his [id].
///
/// A user has to use his email and password to log him in.
/// For security and privacy reasons neither of thoses are stored.
///
/// When a user is logged in a [token] (JWT) is given to him
/// with an [expiresIn] time.
class UserModel {
  String id;
  String token;
  int expiresIn;

  UserModel({
    this.id,
    this.token,
    this.expiresIn,
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
      );
    }

    return UserModel(
      token: json['token'],
      expiresIn: json['expiresIn'],
    );
  }
}