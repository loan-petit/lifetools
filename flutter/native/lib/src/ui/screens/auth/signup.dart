import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter_app/src/blocs/user_bloc.dart';
import 'package:flutter_app/src/ui/widgets/shared/arc_hero/index.dart';
import 'package:flutter_app/src/ui/widgets/shared/loading_screen.dart';
import 'package:flutter_app/src/utils/field_validator.dart';
import 'package:flutter_app/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to the user to retrieve his credentials and sign him up.
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable email [TextFormField].
  final _email = TextEditingController();

  /// Controller for the editable password [TextFormField].
  final _password = TextEditingController();

  /// Controller for the editable password confirmation [TextFormField].
  final _passwordConfirmation = TextEditingController();

  /// If true, validate and update the [TextFormField] error text
  /// after every changes.
  bool _autoValidate = false;

  /// If true, display the [LoadingScreen] during asynchronous operations.
  bool _isLoadingVisible = false;

  /// If true, display a [Text] to indicate invalid credentials.
  bool _areCredentialsInvalid = false;

  /// Manages the business logic related to the user sign up.
  final _userBloc = UserBloc();

  /// Dispose of the [UserBloc].
  @override
  void dispose() {
    _userBloc.dispose();

    super.dispose();
  }

  /// Build the sign up [Form] and its widgets.
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      controller: _email,
      validator: FieldValidator.validateEmail,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      obscureText: true,
      controller: _password,
      validator: FieldValidator.validatePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final passwordConfirmation = TextFormField(
      obscureText: true,
      controller: _passwordConfirmation,
      validator: FieldValidator.validatePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        hintText: 'Confirm your password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _signUp({
            'email': _email.text,
            'password': _password.text,
            'passwordConfirmation': _passwordConfirmation.text,
          });
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text("SIGN UP", style: TextStyle(color: Colors.white)),
      ),
    );

    final errorLabel = Text(
      'Invalid email or password.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.body2.apply(color: Colors.red),
    );

    // If the user already has an account, he has to sign in instead.
    final signInLabel = FlatButton(
      child: Text(
        'Already have an account ? Sign In.',
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/auth/signin');
      },
    );

    return LoadingScreen(
      isInAsyncCall: _isLoadingVisible,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ArcHero(
              hero: FlutterLogo(
                colors: Colors.yellow,
                size: MediaQuery.of(context).size.height / 8,
              ),
              arcContent: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        email,
                        SizedBox(height: 24.0),
                        password,
                        SizedBox(height: 24.0),
                        passwordConfirmation,
                        SizedBox(height: 12.0),
                        signUpButton,
                        if (_areCredentialsInvalid) errorLabel,
                        signInLabel,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Invert the [_isLoadingVisible] boolean to display the [LoadingScreen]
  /// during asynchronous operations.
  Future<void> _changeLoadingVisible() async {
    setState(() => _isLoadingVisible = !_isLoadingVisible);
  }

  /// Manage changes in UI before, during and after user sign up.
  ///
  /// Retrieve user's credentials in order to send these to the [UserBloc]
  /// which will handle all the business logic needed to sign the user up.
  void _signUp(Map<String, String> credentials) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        await _userBloc.signUp(credentials);
        await Navigator.pushNamedAndRemoveUntil(
            context, '/auth/signin', (_) => false);
      } on GraphqlException {
        // Notify the user that an error happend.
        await _changeLoadingVisible();
        setState(() => _areCredentialsInvalid = true);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
