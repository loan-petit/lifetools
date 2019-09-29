import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pedantic/pedantic.dart';

import 'package:lifetools/src/blocs/daily_routine.dart';
import 'package:lifetools/src/models/daily_routine_event.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/field_validator.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';
import 'package:lifetools/src/utils/time.dart';

/// Display a [Form] to create or update a daily routine event.
class UpsertDailyRoutineEvent extends StatefulWidget {
  /// Daily routine event data.
  final DailyRoutineEventModel dailyRoutineEvent;

  UpsertDailyRoutineEvent({
    this.dailyRoutineEvent,
  });

  @override
  _UpsertDailyRoutineEventState createState() =>
      _UpsertDailyRoutineEventState();
}

class _UpsertDailyRoutineEventState extends State<UpsertDailyRoutineEvent> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable name [TextFormField].
  final _name = TextEditingController();

  /// Controller of startTime value editable with time picker.
  TimeOfDay _startTime;

  /// Controller of endTime value editable with time picker.
  TimeOfDay _endTime;

  /// If true, validate and update the [TextFormField] error text
  /// after every changes.
  bool _autoValidate = false;

  /// Error string. Set to null if there isn't any errors.
  String _error;

  /// If true, display the [LoadingScreen] during asynchronous operations.
  bool _isLoadingVisible = false;

  /// Manages the business logic related to daily routine event updates.
  final _dailyRoutineBloc = DailyRoutineBloc();

  /// Initialize form controllers based on [widget.dailyRoutineEvent].
  @override
  void initState() {
    super.initState();

    if (widget.dailyRoutineEvent?.name != null) {
      _name.value = _name.value.copyWith(
        text: widget.dailyRoutineEvent.name,
        selection: TextSelection(
            baseOffset: widget.dailyRoutineEvent.name.length,
            extentOffset: widget.dailyRoutineEvent.name.length),
        composing: TextRange.empty,
      );
    }
    _startTime =
        widget.dailyRoutineEvent?.startTime ?? TimeOfDay(hour: 12, minute: 0);
    _endTime =
        widget.dailyRoutineEvent?.endTime ?? TimeOfDay(hour: 12, minute: 0);
  }

  /// Dispose of the [DailyRoutineBloc].
  @override
  void dispose() {
    _name.dispose();
    _dailyRoutineBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        // Delete button
        if (widget.dailyRoutineEvent != null)
          _buildActionButton(
            onPressed: () {
              _deleteEvent();
            },
            iconData: Icons.clear,
            labelText: "Delete",
          ),
        // Create/Save button
        _buildActionButton(
          onPressed: () {
            if (Time.timeOfDayToSeconds(_startTime) >
                Time.timeOfDayToSeconds(_endTime)) {
              setState(() {
                _error = "Start time should be before the end time.";
              });
            } else {
              _upsertEvent({
                'name': _name.text,
                'startTime': Time.timeOfDayToSeconds(_startTime),
                'endTime': Time.timeOfDayToSeconds(_endTime),
              });
            }
          },
          iconData: (widget.dailyRoutineEvent != null) ? Icons.done : Icons.add,
          labelText: (widget.dailyRoutineEvent != null) ? "Save" : "Create",
        ),
      ],
      content: _buildForm(),
    );
  }

  /// Create [FlatButton] used for the [AlertDialog.actions].
  Widget _buildActionButton({
    @required VoidCallback onPressed,
    @required IconData iconData,
    @required String labelText,
  }) {
    return FlatButton.icon(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      label: Text(
        labelText,
        style: Theme.of(context).textTheme.subhead.apply(
              fontWeightDelta: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }

  /// Form to create or update a daily routine event.
  Form _buildForm() {
    final name = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      controller: _name,
      validator: FieldValidator.validateText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Title',
      ),
    );

    final startTimePicker = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Start Time"),
        FlatButton(
          onPressed: () async {
            _startTime = await _showTimePicker(_startTime) ?? _startTime;
            setState(() {
              // Update _startTime with picked time.
            });
          },
          shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2.0),
          ),
          child: Text(_startTime.format(context)),
        ),
      ],
    );

    final endTimePicker = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("End Time"),
        FlatButton(
          onPressed: () async {
            _endTime = await _showTimePicker(_endTime) ?? _endTime;
            setState(() {
              // Update _endTime with picked time.
            });
          },
          shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2.0),
          ),
          child: Text(_endTime.format(context)),
        ),
      ],
    );

    final errorLabel = Text(
      _error ?? '',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.body2.apply(color: Colors.red),
    );

    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          name,
          SizedBox(height: 24.0),
          startTimePicker,
          SizedBox(height: 24.0),
          endTimePicker,
          if (_error != null) SizedBox(height: 24.0),
          if (_error != null) errorLabel,
        ],
      ),
    );
  }

  /// Wrapper around [showTimePicker] used apply a theme on the time picker.
  Future<TimeOfDay> _showTimePicker(TimeOfDay initialTime) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(primaryColorBrightness: Brightness.dark),
          child: child,
        );
      },
    );
  }

  /// Invert the [_isLoadingVisible] boolean to display the [LoadingScreen]
  /// during asynchronous operations.
  Future<void> _changeLoadingVisible() async {
    setState(() => _isLoadingVisible = !_isLoadingVisible);
  }

  /// Upsert an event and manage UI changes before, during and after the operation.
  ///
  /// Send [data] to the [DailyRoutineBloc] which will handle
  /// the business logic needed to create or update an event.
  Future<void> _upsertEvent(Map<String, dynamic> data) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        if (widget.dailyRoutineEvent?.id != null) {
          await _dailyRoutineBloc.updateOneEvent(
            widget.dailyRoutineEvent.id,
            data,
          );
        } else {
          await _dailyRoutineBloc.createOneEvent(data);
        }
        Navigator.pop(context);
      } on GraphQLException {
        // Notify the user that an error happend.
        await _changeLoadingVisible();
        setState(() {
          _error = 'An unexpected error occured, please retry.';
        });
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  /// Delete the event and manage UI changes before, during and after
  /// the operation.
  Future<void> _deleteEvent() async {
    try {
      // Hide keyboard as the user won't update the event.
      unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
      await _changeLoadingVisible();
      await _dailyRoutineBloc.deleteOneEvent(widget.dailyRoutineEvent.id);
      Navigator.pop(context);
    } on GraphQLException {
      // Notify the user that an error happend.
      await _changeLoadingVisible();
      setState(() {
        _error = 'An unexpected error occured, please retry.';
      });
    }
  }
}
