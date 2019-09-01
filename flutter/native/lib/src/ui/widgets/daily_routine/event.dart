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
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      color: Theme.of(context).accentColor,
      child: Container(
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: _buildLeading(),
          title: Text(widget.dailyRoutineEvent.name),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  /// Build the [ListTile.leading].
  Widget _buildLeading() {
    return Container(
      width: 90.0,
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 2.0, color: Theme.of(context).primaryColor),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.dailyRoutineEvent.startTime.format(context),
            style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 2),
          ),
          if (widget.dailyRoutineEvent.startTime !=
              widget.dailyRoutineEvent.endTime)
            Text(widget.dailyRoutineEvent.endTime.format(context)),
        ],
      ),
    );
  }

  /// Build the [ListTile.trailing].
  Widget _buildTrailing() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
        ),
      ),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return UpsertDailyRoutineEvent(
                  dailyRoutineEvent: widget.dailyRoutineEvent);
            },
          );
        },
        color: Theme.of(context).textTheme.body1.color,
        icon: Icon(
          Icons.navigate_next,
          size: 30.0,
        ),
      ),
    );
  }
}
