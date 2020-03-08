import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/inherited_widgets/daily_routine_bloc_provider.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/daily_routine/upsert_event.dart';
import 'package:lifetools/src/ui/widgets/shared/tile.dart';
import 'package:lifetools/src/utils/size_config.dart';
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
    return Tile(
      leading: _buildLeading(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.dailyRoutineEvent.name),
          _buildSubtitle(),
        ],
      ),
      trailing: _buildTrailing(),
    );
  }

  /// Build the [Tile.leading] widget.
  Widget _buildLeading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.dailyRoutineEvent.startTime.format(context),
          style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 2),
        ),
        if (widget.dailyRoutineEvent.startTime !=
            widget.dailyRoutineEvent.endTime)
          Text(widget.dailyRoutineEvent.endTime.format(context)),
      ],
    );
  }

  /// Build the [Tile.body] widget's subtitle.
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
        SizedBox(width: 10 * SizeConfig.sizeMultiplier),
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

  /// Build the [Tile.trailing] widget.
  Widget _buildTrailing() {
    return GestureDetector(
      onTap: () async {
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
      child: Icon(
        Icons.edit,
        size: 30 * SizeConfig.sizeMultiplier,
      ),
    );
  }
}
