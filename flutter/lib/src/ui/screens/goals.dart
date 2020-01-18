import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/goal.dart';
import 'package:lifetools/src/blocs/inherited_widgets/goal_bloc_provider.dart';
import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/ui/widgets/goals/goal.dart';
import 'package:lifetools/src/ui/widgets/goals/upsert_goal.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/index.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/size_config.dart';

/// Display the goals of a user.
class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  /// Manage the business logic related to the goals.
  GoalBloc _goalBloc;

  /// Retrieve the goals.
  @override
  void didChangeDependencies() {
    _goalBloc = GoalsBlocProvider.of(context);
    _goalBloc.fetchMany(fromCurrentUser: true);

    super.didChangeDependencies();
  }

  /// Dispose of the [GoalBloc].
  @override
  void dispose() {
    _goalBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder(
        stream: _goalBloc.goals,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3 * SizeConfig.heightMultiplier,
                horizontal: 2 * SizeConfig.widthMultiplier,
              ),
              child: Text(
                "An error occured during the retrieval of your goals.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .apply(color: Colors.red, fontWeightDelta: 2),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingScreen(child: _buildGoals(snapshot.data));
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              return _buildGoals(snapshot.data);
          }
          return null; // unreachable
        },
      ),
      floatingActionButtonBuilder: _buildFloatingActionButton,
    );
  }

  /// Build the list of goals.
  Widget _buildGoals(Iterable<GoalModel> data) {
    if (data == null) return Container();

    List<GoalModel> goals = data.toList();

    final header = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 2 * SizeConfig.heightMultiplier),
        Text(
          "Goals",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1.apply(
                fontWeightDelta: 3,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 2 * SizeConfig.heightMultiplier),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
          child: Text(
            "\"A goal properly set is halfway reached.\"",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SizedBox(height: 4 * SizeConfig.heightMultiplier),
      ],
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: header),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => Goal(goal: goals[index]),
            childCount: goals.length,
          ),
        ),
      ],
    );
  }

  /// Build a floating action button used to create a new goal.
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) {
            return UpsertGoal();
          },
        );
        await _goalBloc.fetchMany(
          fromCurrentUser: true,
          updateCache: true,
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      tooltip: "Create a new event in your daily routine.",
      child: Icon(Icons.add),
    );
  }
}
