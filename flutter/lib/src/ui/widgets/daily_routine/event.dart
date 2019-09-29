import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/upsert_event.dart';
import 'package:lifetools/src/utils/time.dart';

/// Build a daily routine event based on a [ListTile].
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
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      child: Container(
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: _buildLeading(),
          title: Text(widget.dailyRoutineEvent.name),
          subtitle: _buildSubtitle(),
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
          right: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
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

  /// Build the [ListTile.subtitle]
  Widget _buildSubtitle() {
    IconData iconData;
    String status;

    if (Time.timeOfDayToSeconds(widget.dailyRoutineEvent.startTime) >
        Time.timeOfDayToSeconds(TimeOfDay.now())) {
      iconData = Icons.clear;
      status = "Not passed";
    } else if (Time.timeOfDayToSeconds(widget.dailyRoutineEvent.endTime) <
        Time.timeOfDayToSeconds(TimeOfDay.now())) {
      iconData = Icons.done;
      status = "Passed";
    } else {
      iconData = Icons.schedule;
      status = "In progress";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Icon(
            iconData,
            size: Theme.of(context).textTheme.body1.fontSize,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
            flex: 2,
            child: Text(
              status,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.body2,
            )),
      ],
    );
  }

  /// Build the [ListTile.trailing].
  Widget _buildTrailing() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2.0),
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
        color: Theme.of(context).colorScheme.onBackground,
        icon: Icon(
          Icons.edit,
          size: 30.0,
        ),
      ),
    );
  }
}
