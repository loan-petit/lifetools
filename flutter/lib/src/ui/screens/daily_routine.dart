import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/daily_routine.dart';
import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/upsert_event.dart';
import 'package:lifetools/src/ui/widgets/shared/app_scaffold.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/time.dart';

/// Display the logged in user's daily routine.
class DailyRoutine extends StatefulWidget {
  @override
  _DailyRoutineState createState() => _DailyRoutineState();
}

class _DailyRoutineState extends State<DailyRoutine> {
  /// Manage the business logic related to the daily routine.
  DailyRoutineBloc _dailyRoutineBloc;

  /// Retrieve the daily routine.
  @override
  void didChangeDependencies() {
    _dailyRoutineBloc = DailyRoutineBlocProvider.of(context);
    _dailyRoutineBloc.fetch();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder(
        stream: _dailyRoutineBloc.dailyRoutine,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                "An error occured during the retrieval of your daily routine.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .apply(color: Colors.red, fontWeightDelta: 2),
              ),
            );
          }
          if (snapshot.hasData) {
            return _buildDailyRoutine(snapshot.data);
          }
          return LoadingScreen(child: _buildDailyRoutine(snapshot.data));
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
        Text(
          "Daily Routine",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1.apply(
                fontWeightDelta: 3,
              ),
        ),
        SizedBox(height: 16.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(26.0),
          child: Container(
            width: 200.0,
            height: 8.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 36.0),
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) {
            return UpsertDailyRoutineEvent();
          },
        );
        await _dailyRoutineBloc.fetch();
      },
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).accentColor,
      tooltip: "Create a new event in your daily routine.",
      child: Icon(Icons.add),
    );
  }
}
