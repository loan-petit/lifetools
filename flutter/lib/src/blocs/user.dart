import 'package:lifetools/src/utils/graphql/graphql_helper.dart';
import 'package:rxdart/rxdart.dart';

import 'package:lifetools/src/models/user.dart';
import 'package:lifetools/src/resources/user_provider.dart';
import 'package:lifetools/src/services/data_persistence_service/index.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Manage the business logic related to the users.
class UserBloc {
  /// Take care of the data persistence, necessary to keep user logged in
  /// during his subsequents accesses to the app.
  static final _dataPersistenceService = DataPersistenceService();

  /// Provider CRUD operations for
  final UserProvider _usersProvider = UserProvider();

  /// Sink and Streams controller.
  final PublishSubject<UserModel> _usersSubject = PublishSubject<UserModel>();

  /// Stream of user.
  Observable<UserModel> get user => _usersSubject.stream;

  /// Dispose of the the [_usersSubject] to close all open streams.
  dispose() {
    _usersSubject.close();
  }

  /// True if the user is logged in, false otherwise.
  static bool get isLoggedIn {
    String idToken = _dataPersistenceService.get('id_token');
    String expiresAt = _dataPersistenceService.get('expires_at');

    if ((idToken?.isEmpty ?? true) || (expiresAt?.isEmpty ?? true)) {
      return false;
    }

    return DateTime.now().isBefore(DateTime.parse(expiresAt));
  }

  /// Sign the user out by removing is JWT token from the LocalStorage.
  static void signOut() {
    _dataPersistenceService.remove('id_token');
    _dataPersistenceService.remove('expires_at');
    GraphQLHelper().init();
  }

  /// Retrieve user's credentials and sign him in.
  ///
  /// The informations needed by the GraphQL API to sign the user in
  /// are stored in [credentials].
  Future<void> signIn(Map<String, String> credentials) async {
    UserModel userModel = await _usersProvider.signIn(credentials);
    _storeJwt(userModel.token, userModel.expiresIn);
  }

  /// Retrieve user's credentials and sign him up.
  ///
  /// The informations needed by the GraphQL API to sign the user up
  /// are stored in [credentials].
  Future<void> signUp(Map<String, String> credentials) async {
    await _usersProvider.signUp(credentials);
  }

  /// Retrieve informations about the current user.
  Future<void> getCurrentUser() async {
    try {
      UserModel userModel = await _usersProvider.getCurrentUser();
      _usersSubject.sink.add(userModel);
    } on GraphQLException catch (e) {
      _usersSubject.sink.addError(e);
    }
  }

  /// Persist the JWT [token] and its expiration date.
  /// Those informations will be used to check if a user is logged in and
  /// to provide access to GraphQL resolvers restricted to authenticated users.
  ///
  /// The expiration date is determined based on the [expiresIn] time.
  void _storeJwt(String token, int expiresIn) {
    _dataPersistenceService.set('id_token', token);
    _dataPersistenceService.set(
      'expires_at',
      DateTime.now()
          .add(
            Duration(seconds: expiresIn),
          )
          .toString(),
    );
    GraphQLHelper().init();
  }
}
