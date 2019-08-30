import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/blocs/daily_routine_bloc.dart';
import 'package:flutter_app/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:flutter_app/src/models/daily_routine_item.dart';
import 'package:flutter_app/src/ui/widgets/daily_routine_item.dart';
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
    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: _dailyRoutineBloc.dailyRoutine,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 12.0),
                child: Text(
                  "An error occured during the retrieval of your daily routine.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              return _buildItemList(snapshot.data);
            }
            return LoadingScreen(child: _buildItemList(snapshot.data));
          },
        ),
        _buildFab(),
      ],
    );
  }

  /// Build the list of items in the daily routine.
  Widget _buildItemList(Iterable<DailyRoutineItemModel> data) {
    if (data == null) return Container();

    final List<DailyRoutineItemModel> dailyRoutine = data.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: dailyRoutine.length,
      itemBuilder: (BuildContext context, int index) =>
          DailyRoutineItem(dailyRoutineItem: dailyRoutine[index]),
    );
  }

  Widget _buildFab() {
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/upsert-daily-routine-item');
        },
        tooltip: "Create a new event in your daily routine.",
        child: Icon(Icons.add),
      ),
    );
  }
}
