import 'package:pedantic/pedantic.dart';

import 'package:flutter/material.dart';

import 'package:flutter_app/src/models/daily_routine_item.dart';

/// Build a list item based on a [ListTile].
///
/// The item data has to be send to [dailyRoutineItem].
class DailyRoutineItem extends StatefulWidget {
  final DailyRoutineItemModel dailyRoutineItem;

  DailyRoutineItem({
    @required this.dailyRoutineItem,
  }) : assert(dailyRoutineItem != null);

  @override
  _DailyRoutineItemState createState() => _DailyRoutineItemState();
}

class _DailyRoutineItemState extends State<DailyRoutineItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: _buildLeading(),
        title: Text(widget.dailyRoutineItem.name),
        trailing: Icon(
          Icons.navigate_next,
          size: 30.0,
        ),
      ),
    );
  }

  /// Build the [ListTile.leading].
  Widget _buildLeading() {
    final startTime = TimeOfDay.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(
        widget.dailyRoutineItem.startTime * 1000,
      ),
    );
    final endTime = TimeOfDay.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(
        widget.dailyRoutineItem.endTime * 1000,
      ),
    );

    return Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1.0, color: Colors.white24)),
      ),
      child: Column(
        children: <Widget>[
          Text(startTime.toString()),
          Text(endTime.toString()),
        ],
      ),
    );
  }
}
