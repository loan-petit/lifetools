import 'dart:async';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifetools/src/blocs/goal.dart';

import 'package:pedantic/pedantic.dart';

import 'package:lifetools/src/models/goal.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/field_validator.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to create or update a goal.
class UpsertGoal extends StatefulWidget {
  /// Goal data.
  final GoalModel goal;

  UpsertGoal({
    this.goal,
  });

  @override
  _UpsertGoalState createState() => _UpsertGoalState();
}

class _UpsertGoalState extends State<UpsertGoal> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable name [TextFormField].
  final _name = TextEditingController();

  /// Controller of date value editable with time picker.
  DateTime _date;

  /// If true, validate and update the [TextFormField] error text
  /// after every changes.
  bool _autoValidate = false;

  /// Error string. Set to null if there isn't any errors.
  String _error;

  /// If true, display the [LoadingScreen] during asynchronous operations.
  bool _isLoadingVisible = false;

  /// Manages the business logic related to goal updates.
  final _goalBloc = GoalBloc();

  /// Initialize form controllers based on [widget.goalEvent].
  @override
  void initState() {
    super.initState();

    if (widget.goal?.name != null) {
      _name.value = _name.value.copyWith(
        text: widget.goal.name,
        selection: TextSelection(
            baseOffset: widget.goal.name.length,
            extentOffset: widget.goal.name.length),
        composing: TextRange.empty,
      );
    }

    _date = widget.goal?.date ?? DateTime.now();
  }

  /// Dispose of the [UserBloc] and the [GoalBloc].
  @override
  void dispose() {
    _name.dispose();
    _goalBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        // Delete button
        if (widget.goal != null)
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
            _upsertEvent({
              'name': _name.text,
              'date': _date.toUtc().toIso8601String(),
            });
          },
          iconData: (widget.goal != null) ? Icons.done : Icons.add,
          labelText: (widget.goal != null) ? "Save" : "Create",
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
        color: Theme.of(context).textTheme.body1.color,
      ),
      label: Text(
        labelText,
        style: Theme.of(context).textTheme.subhead.apply(
              fontWeightDelta: 2,
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
        hintText: 'Event name',
      ),
    );

    final datePicker = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Date"),
        SizedBox(width: 5),
        FlatButton(
          onPressed: () async {
            DateTime now = DateTime.now();
            _date = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: _date.add(Duration(days: 14)),
                ) ??
                _date;
            setState(() {
              // Update _date with picked date.
            });
          },
          shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
          ),
          child: Text(DateFormat.yMEd().format(_date)),
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
          datePicker,
          if (_error != null) SizedBox(height: 24.0),
          if (_error != null) errorLabel,
        ],
      ),
    );
  }

  /// Invert the [_isLoadingVisible] boolean to display the [LoadingScreen]
  /// during asynchronous operations.
  Future<void> _changeLoadingVisible() async {
    setState(() => _isLoadingVisible = !_isLoadingVisible);
  }

  /// Upsert an event and manage UI changes before, during and after the operation.
  ///
  /// Send [data] to the [GoalBloc] which will handle
  /// the business logic needed to create or update a goal.
  Future<void> _upsertEvent(Map<String, dynamic> data) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        if (widget.goal?.id != null) {
          await _goalBloc.updateOne(widget.goal.id, data);
        } else {
          await _goalBloc.createOne(data);
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

  /// Delete an event and manage UI changes before, during and after the operation.
  Future<void> _deleteEvent() async {
    try {
      // Hide keyboard as the user won't update the event.
      unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
      await _changeLoadingVisible();
      await _goalBloc.deleteOne(widget.goal.id);
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
