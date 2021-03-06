import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/daily_routine.dart';
import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/upsert_event.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/index.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/size_config.dart';
import 'package:lifetools/src/utils/time.dart';

/// Display the daily routine of a user.
class DailyRoutineScreen extends StatefulWidget {
  @override
  _DailyRoutineScreenState createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  /// Manage the business logic related to the daily routine.
  DailyRoutineBloc _dailyRoutineBloc;

  /// Retrieve the daily routine.
  @override
  void didChangeDependencies() {
    _dailyRoutineBloc = DailyRoutineBlocProvider.of(context);
    _dailyRoutineBloc.fetch(fromCurrentUser: true);

    super.didChangeDependencies();
  }

  /// Dispose of the [DailyRoutineBloc].
  @override
  void dispose() {
    _dailyRoutineBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder(
        stream: _dailyRoutineBloc.dailyRoutine,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25 * SizeConfig.sizeMultiplier,
                horizontal: 15 * SizeConfig.sizeMultiplier,
              ),
              child: Text(
                "An error occured during the retrieval of your daily routine.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(color: Colors.red, fontWeightDelta: 2),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingScreen(child: _buildDailyRoutine(snapshot.data));
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              return _buildDailyRoutine(snapshot.data);
          }
          return null; // unreachable
        },
      ),
      floatingActionButtonBuilder: _buildFloatingActionButton,
    );
  }

  /// Build the list of events in the daily routine.
  Widget _buildDailyRoutine(Iterable<DailyRoutineEventModel> data) {
    if (data == null) return Container();

    List<DailyRoutineEventModel> dailyRoutine = data.toList();
    dailyRoutine.sort((a, b) {
      if (a.startTime != b.startTime) {
        return Time.timeOfDayToSeconds(a.startTime)
            .compareTo(Time.timeOfDayToSeconds(b.startTime));
      } else {
        return Time.timeOfDayToSeconds(a.endTime)
            .compareTo(Time.timeOfDayToSeconds(b.endTime));
      }
    });

    final header = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 15 * SizeConfig.sizeMultiplier),
        Text(
          "Daily Routine",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4.apply(
                fontWeightDelta: 3,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 15 * SizeConfig.sizeMultiplier),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 30 * SizeConfig.sizeMultiplier),
          child: Text(
            "\"You will never change your life until you change something you do daily.\"",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 30 * SizeConfig.sizeMultiplier),
      ],
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: header),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) =>
                DailyRoutineEvent(dailyRoutineEvent: dailyRoutine[index]),
            childCount: dailyRoutine.length,
          ),
        ),
      ],
    );
  }

  /// Build a floating action button used to create a new DailyRoutineEvent.
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) {
            return UpsertDailyRoutineEvent();
          },
        );
        await _dailyRoutineBloc.fetch(
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
