import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:lifetools/src/blocs/inherited_widgets/goal_bloc_provider.dart';
import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/ui/screens/auth/signin.dart';
import 'package:lifetools/src/ui/screens/auth/signup.dart';
import 'package:lifetools/src/ui/screens/daily_routine.dart';
import 'package:lifetools/src/ui/screens/goals.dart';
import 'package:lifetools/src/ui/screens/profile.dart';

/// Build the appropriate [MaterialPageRoute] on route navigation.
class Router {
  /// Callback function used by the [MaterialApp] on route navigation.
  ///
  /// The requested routed is described in [settings].
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (!UserBloc.isLoggedIn) {
      switch (settings.name) {
        // Sign a user in
        case '/auth/signin':
          return MaterialPageRoute(
              settings: settings, builder: (_) => SignInScreen());
        // Sign a user up
        default:
          return MaterialPageRoute(
              settings: settings, builder: (_) => SignUpScreen());
      }
    } else if (UserBloc.isLoggedIn) {
      switch (settings.name) {
        // Sign a user out
        case '/auth/signout':
          UserBloc.signOut();
          break;
        // Display the goals
        case '/goals-events':
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => GoalsBlocProvider(child: Goals()),
          );
        // Display the profile of a user
        case '/profile':
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProfileScreen(),
          );
        // Display the daily routine
        case '/daily-routine':
        default:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => DailyRoutineBlocProvider(child: DailyRoutine()),
          );
      }
    }
    // Sign a user up
    return MaterialPageRoute(
        settings: settings, builder: (_) => SignUpScreen());
  }
}
