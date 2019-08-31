import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/ui/widgets/daily_routine/upsert_event.dart';

class UpsertDailyRoutineEventFloatingActionButton extends StatefulWidget {
  @override
  _UpsertDailyRoutineEventFloatingActionButtonState createState() =>
      _UpsertDailyRoutineEventFloatingActionButtonState();
}

class _UpsertDailyRoutineEventFloatingActionButtonState
    extends State<UpsertDailyRoutineEventFloatingActionButton> {
  bool _isFloatingActionButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    if (_isFloatingActionButtonVisible) {
      return FloatingActionButton(
        onPressed: () {
          final bottomSheetController = showBottomSheet(
            context: context,
            builder: (_) {
              return UpsertDailyRoutineEvent();
            },
          );
          setState(() => _isFloatingActionButtonVisible = false);
          bottomSheetController.closed.then((value) {
            setState(() => _isFloatingActionButtonVisible = true);
          });
        },
        tooltip: "Create a new event in your daily routine.",
        child: Icon(Icons.add),
      );
    }
    return Container();
  }
}
