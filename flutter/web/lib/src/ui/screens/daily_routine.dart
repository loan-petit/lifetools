import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/blocs/daily_routine.dart';
import 'package:flutter_app/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:flutter_app/src/models/daily_routine_event.dart';
import 'package:flutter_app/src/ui/widgets/daily_routine/event.dart';
import 'package:flutter_app/src/ui/widgets/daily_routine/upsert_event.dart';
import 'package:flutter_app/src/ui/widgets/shared/app_scaffold.dart';
import 'package:flutter_app/src/ui/widgets/shared/loading_screen.dart';

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
            return _buildEventList(snapshot.data);
          }
          return LoadingScreen(child: _buildEventList(snapshot.data));
        },
      ),
      floatingActionButtonBuilder: _buildFloatingActionButton,
    );
  }

  /// Build the list of events in the daily routine.
  Widget _buildEventList(Iterable<DailyRoutineEventModel> data) {
    if (data == null) return Container();

    final List<DailyRoutineEventModel> dailyRoutine = data.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: dailyRoutine.length,
      itemBuilder: (BuildContext context, int index) =>
          DailyRoutineEvent(dailyRoutineEvent: dailyRoutine[index]),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return UpsertDailyRoutineEvent();
          },
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      tooltip: "Create a new event in your daily routine.",
      child: Icon(Icons.add),
    );
  }
}
