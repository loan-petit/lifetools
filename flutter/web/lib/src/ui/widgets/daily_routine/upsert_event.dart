import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';
import 'package:flutter_app/src/ui/widgets/shared/app_scaffold.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter_app/src/blocs/daily_routine.dart';
import 'package:flutter_app/src/ui/widgets/shared/loading_screen.dart';
import 'package:flutter_app/src/utils/field_validator.dart';
import 'package:flutter_app/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to create or update a daily routine event.
///
/// If you want to update an event, send its ID to the [eventId].
class UpsertDailyRoutineEvent extends StatefulWidget {
  final String eventId;

  UpsertDailyRoutineEvent({this.eventId});

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

  /// If true, validate and update the [TextFormField] error text
  /// after every changes.
  bool _autoValidate = false;

  /// If true, display the [LoadingScreen] during asynchronous operations.
  bool _isLoadingVisible = false;

  /// Manages the business logic related to the user sign in.
  final _dailyRoutineBloc = DailyRoutineBloc();

  /// Dispose of the [DailyRoutineBloc].
  @override
  void dispose() {
    _dailyRoutineBloc.dispose();

    super.dispose();
  }

  /// Build the sign in [Form] and its widgets.
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: _buildAppBar(),
      body: LoadingScreen(
        isInAsyncCall: _isLoadingVisible,
        child: _buildForm(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _upsertEvent({'name': _name.text});
          },
          child: Text("Save"),
        ),
      ],
    );
  }

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

    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                name,
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
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
  /// Send data present in [query] to the [DailyRoutineBloc] which will handle
  /// the business logic needed to create or update an event.
  void _upsertEvent(Map<String, String> query) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        if (widget.eventId != null) {
          await _dailyRoutineBloc
              .updateOneEvent({'id': widget.eventId, ...query});
        } else {
          await _dailyRoutineBloc.createOneEvent(query);
        }
        await Navigator.pop(context);
      } on GraphqlException {
        // Notify the user that an error happend.
        await _changeLoadingVisible();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected Error"),
          ),
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
