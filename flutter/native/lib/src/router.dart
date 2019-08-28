import 'package:flutter/material.dart';

import 'package:flutter_app/src/blocs/user_bloc.dart';
import 'package:flutter_app/src/ui/screens/auth/signin.dart';
import 'package:flutter_app/src/ui/screens/auth/signup.dart';
import 'package:flutter_app/src/ui/widgets/shared/app_scaffold.dart';

/// Build the appropriate [MaterialPageRoute] on route navigation.
class Router {
  /// Callback function used by the [MaterialApp] on route navigation.
  ///
  /// The requested routed is described in [settings].
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (!UserBloc.isLoggedIn) {
      switch (settings.name) {
        case '/auth/signin':
          return buildPage(
            body: SignInScreen(),
            showAppBar: false,
          );
        default:
          return buildPage(
            body: SignUpScreen(),
            showAppBar: false,
          );
      }
    } else if (UserBloc.isLoggedIn) {
      switch (settings.name) {
        case '/auth/signout':
          UserBloc.signOut();
          break;
        default:
          return buildPage(
            body: Container(),
          );
      }
    }
    return buildPage(body: SignUpScreen());
  }

  /// Build a new [MaterialPageRoute] based on the provided parameters.
  ///
  /// Initialize the app base UI with [AppScaffold].
  /// The [AppScaffold] inherits from the [AuthBlocInheritedWidget]
  /// to provide to the whole app inheritance of the [AuthBloc].
  ///
  /// The [title] property is associated to the [Scaffold.title] property.
  ///
  /// Show the scaffold's app bar if [showAppBar] is true.
  MaterialPageRoute buildPage({
    String title,
    bool showAppBar = true,
    @required Widget body,
  }) {
    return MaterialPageRoute(
      builder: (_) => AppScaffold(
        showAppBar: showAppBar,
        title: title,
        body: body,
      ),
    );
  }
}
