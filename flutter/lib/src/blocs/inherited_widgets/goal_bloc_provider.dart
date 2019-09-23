import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/goal.dart';

/// Widget used to share the [GoalsBloc] across a part of the widget tree.
class GoalsBlocProvider extends InheritedWidget {
  final GoalBloc bloc;

  GoalsBlocProvider({
    Key key,
    @required Widget child,
  })  : bloc = GoalBloc(),
        super(key: key, child: child);

  /// Notify every widget below this one in the tree of [GoalsBloc] changes.
  @override
  bool updateShouldNotify(_) {
    return true;
  }

  /// Retrieve the [GoalsBloc] from the context of a widget below this
  /// one in the tree.
  static GoalBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GoalsBlocProvider)
            as GoalsBlocProvider)
        .bloc;
  }
}
