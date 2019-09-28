import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/goal.dart';
import 'package:lifetools/src/blocs/inherited_widgets/goal_bloc_provider.dart';
import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/ui/widgets/goals/upsert_goal.dart';
import 'package:pedantic/pedantic.dart';

/// Build a goal based on a [ListTile].
class Goal extends StatefulWidget {
  /// Goal data.
  final GoalModel goal;

  Goal({
    @required this.goal,
  }) : assert(goal != null);

  @override
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  /// Manage the business logic related to the goals.
  GoalBloc _goalBloc;

  /// Retrieve the goals.
  @override
  void didChangeDependencies() {
    _goalBloc = GoalsBlocProvider.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      color: Theme.of(context).canvasColor,
      child: Container(
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: _buildLeading(),
          title: Text(widget.goal.name),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  /// Build the [ListTile.leading].
  Widget _buildLeading() {
    String semanticLabel;

    if (widget.goal.isCompleted) {
      semanticLabel = 'Goal reached';
    } else {
      semanticLabel = 'Goal to reach';
    }

    return Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 4.0, color: Theme.of(context).primaryColor),
        ),
      ),
      child: IconButton(
        icon: Icon(
          (widget.goal.isCompleted)
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          semanticLabel: semanticLabel,
        ),
        onPressed: () async {
          await _goalBloc.updateOne(
            widget.goal.id,
            {'isCompleted': !widget.goal.isCompleted},
          );
          unawaited(
            _goalBloc.fetchMany(fromCurrentUser: true, updateCache: true),
          );
        },
      ),
    );
  }

  /// Build the [ListTile.trailing].
  Widget _buildTrailing() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 4.0),
        ),
      ),
      child: IconButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          if (widget.goal.date
                  .compareTo(DateTime(now.year, now.month, now.day)) >=
              0) {
            await showDialog(
              context: context,
              builder: (_) {
                return UpsertGoal(goal: widget.goal);
              },
            );
            await GoalsBlocProvider.of(context).fetchMany(
              fromCurrentUser: true,
              updateCache: true,
            );
          }
        },
        color: Theme.of(context).textTheme.body1.color,
        icon: Icon(
          Icons.edit,
          size: 30.0,
        ),
      ),
    );
  }
}
