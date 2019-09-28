import 'package:flutter/material.dart';
import 'package:lifetools/src/blocs/daily_routine.dart';
import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';

import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/upsert_event.dart';

/// Build a list event based on a [ListTile].
class DailyRoutineEvent extends StatefulWidget {
  /// Daily routine event data.
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
      color: Theme.of(context).canvasColor,
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
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 4.0, color: Theme.of(context).primaryColor),
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
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 4.0),
        ),
      ),
      child: IconButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) {
              return UpsertDailyRoutineEvent(
                  dailyRoutineEvent: widget.dailyRoutineEvent);
            },
          );
          await DailyRoutineBlocProvider.of(context).fetch(
            fromCurrentUser: true,
            updateCache: true,
          );
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
