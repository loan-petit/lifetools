import 'package:flutter/material.dart';

import 'package:flutter_app/src/models/daily_routine_event.dart';
import 'package:flutter_app/src/ui/widgets/daily_routine/upsert_event.dart';

/// Build a list event based on a [ListTile].
///
/// The event data has to be send to [dailyRoutineEvent].
class DailyRoutineEvent extends StatefulWidget {
  final DailyRoutineEventModel dailyRoutineEvent;

  DailyRoutineEvent({
    @required this.dailyRoutineEvent,
  }) : assert(dailyRoutineEvent != null);

  @override
  _DailyRoutineEventState createState() => _DailyRoutineEventState();
}

class _DailyRoutineEventState extends State<DailyRoutineEvent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: _buildLeading(),
        title: Text(widget.dailyRoutineEvent.name),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return UpsertDailyRoutineEvent(
                    dailyRoutineEvent: widget.dailyRoutineEvent);
              },
            );
          },
          icon: Icon(
            Icons.navigate_next,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  /// Build the [ListTile.leading].
  Widget _buildLeading() {
    return Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1.0, color: Colors.white24)),
      ),
      child: Column(
        children: <Widget>[
          Text(widget.dailyRoutineEvent.startTime.format(context)),
          Text(widget.dailyRoutineEvent.endTime.format(context)),
        ],
      ),
    );
  }
}
