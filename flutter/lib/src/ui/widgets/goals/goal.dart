import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/goal.dart';
import 'package:lifetools/src/blocs/inherited_widgets/goal_bloc_provider.dart';
import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/ui/widgets/goals/upsert_goal.dart';
import 'package:lifetools/src/ui/widgets/shared/tile.dart';
import 'package:lifetools/src/utils/size_config.dart';
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
    return Tile(
      leading: _buildLeading(),
      body: Text(widget.goal.name),
      trailing: _buildTrailing(),
    );
  }

  /// Build the [Tile.leading] widget.
  Widget _buildLeading() {
    String semanticLabel;

    if (widget.goal.isCompleted) {
      semanticLabel = 'Goal reached';
    } else {
      semanticLabel = 'Goal to reach';
    }

    return IconButton(
      onPressed: () async {
        await _goalBloc.updateOne(
          widget.goal.id,
          {'isCompleted': !widget.goal.isCompleted},
        );
        unawaited(
          _goalBloc.fetchMany(fromCurrentUser: true, updateCache: true),
        );
      },
      icon: Icon(
        (widget.goal.isCompleted)
            ? Icons.check_box
            : Icons.check_box_outline_blank,
        semanticLabel: semanticLabel,
        size: 3 * SizeConfig.textMultiplier,
      ),
    );
  }

  /// Build the [Tile.trailing] widget.
  Widget _buildTrailing() {
    return GestureDetector(
      onTap: () async {
        DateTime now = DateTime.now();
        if (widget.goal.date.compareTo(
              DateTime(now.year, now.month, now.day),
            ) >=
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
      child: Icon(
        Icons.edit,
        size: 4 * SizeConfig.textMultiplier,
      ),
    );
  }
}
