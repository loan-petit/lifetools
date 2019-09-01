import 'package:flutter/material.dart';

import 'package:LifeTools/src/blocs/daily_routine.dart';

/// Widget used to share the [DailyRoutineBloc] across a part of the widget tree.
class DailyRoutineBlocProvider extends InheritedWidget {
  final DailyRoutineBloc bloc;

  DailyRoutineBlocProvider({
    Key key,
    @required Widget child,
  })  : bloc = DailyRoutineBloc(),
        super(key: key, child: child);

  /// Notify every widget below this one in the tree of [DailyRoutineBloc]
  /// changes.
  @override
  bool updateShouldNotify(_) {
    return true;
  }

  /// Retrieve the [DailyRoutineBloc] from the context of a widget below this
  /// one in the tree.
  static DailyRoutineBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DailyRoutineBlocProvider)
            as DailyRoutineBlocProvider)
        .bloc;
  }
}
