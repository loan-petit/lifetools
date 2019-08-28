import 'package:flutter/material.dart';

import 'package:flutter_app/src/blocs/user_bloc.dart';

/// Widget used to share the [UsersBloc] across a part of the widget tree.
class UserBlocProvider extends InheritedWidget {
  final UserBloc bloc;

  UserBlocProvider({
    Key key,
    @required Widget child,
  })  : bloc = UserBloc(),
        super(key: key, child: child);

  /// Notify every widget below this one in the tree of [UsersBloc] changes.
  @override
  bool updateShouldNotify(_) {
    return true;
  }

  /// Retrieve the [UsersBloc] from the context of a widget below this one
  /// in the tree.
  static UserBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UserBlocProvider)
            as UserBlocProvider)
        .bloc;
  }
}
