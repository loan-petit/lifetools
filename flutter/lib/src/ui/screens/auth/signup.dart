import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifetools/src/utils/size_config.dart';

import 'package:pedantic/pedantic.dart';

import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/index.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/field_validator.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to the user to retrieve his credentials and sign him up.
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable username [TextFormField].
  final _username = TextEditingController();

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
    _username.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();
    _userBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.display2.apply(fontWeightDelta: 2),
        children: <TextSpan>[
          TextSpan(text: 'Life'),
          TextSpan(
            text: 'Tools',
            style: Theme.of(context).textTheme.display2.apply(
                fontWeightDelta: 2,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );

    final username = TextFormField(
      autofocus: true,
      controller: _username,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Username',
      ),
    );

    final password = TextFormField(
      obscureText: true,
      controller: _password,
      validator: FieldValidator.validatePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
    );

    final passwordConfirmation = TextFormField(
      obscureText: true,
      controller: _passwordConfirmation,
      validator: FieldValidator.validatePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Confirm your password',
      ),
    );

    final signUpButton = FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        _signUp({
          'username': _username.text,
          'password': _password.text,
          'passwordConfirmation': _passwordConfirmation.text,
        });
      },
      padding: EdgeInsets.all(10 * SizeConfig.sizeMultiplier),
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        "SIGN UP",
        style: Theme.of(context).textTheme.button.apply(
              fontWeightDelta: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );

    final errorLabel = Text(
      'Oops. Something went wrong. Please try again later.',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .body2
          .apply(color: Theme.of(context).colorScheme.error),
    );

    // If the user already has an account, he has to sign in instead.
    final signInLabel = FlatButton(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 2),
          children: <TextSpan>[
            TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Sign in.',
              style: Theme.of(context).textTheme.body1.apply(
                  fontWeightDelta: 2,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/auth/signin');
      },
    );

    return AppScaffold(
      showAppBar: false,
      body: LoadingScreen(
        isInAsyncCall: _isLoadingVisible,
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Padding(
            padding: EdgeInsets.all(25 * SizeConfig.sizeMultiplier),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    SizedBox(height: 30 * SizeConfig.sizeMultiplier),
                    username,
                    SizedBox(height: 25 * SizeConfig.sizeMultiplier),
                    password,
                    SizedBox(height: 25 * SizeConfig.sizeMultiplier),
                    passwordConfirmation,
                    if (_areCredentialsInvalid)
                      SizedBox(height: 25 * SizeConfig.sizeMultiplier),
                    if (_areCredentialsInvalid) errorLabel,
                    SizedBox(height: 30 * SizeConfig.sizeMultiplier),
                    signUpButton,
                    SizedBox(height: 15 * SizeConfig.sizeMultiplier),
                    signInLabel,
                  ],
                ),
              ),
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

  /// Sign a user up and manage UI changes before, during and after the operation.
  ///
  /// Retrieve user's [credentials] in order to send these to the [UserBloc]
  /// which will handle all the business logic needed to sign the user up.
  Future<void> _signUp(Map<String, String> credentials) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        await _userBloc.signUp(credentials);
        await Navigator.pushNamedAndRemoveUntil(
            context, '/auth/signin', (_) => false);
      } on GraphQLException {
        // Notify the user that an error happend.
        await _changeLoadingVisible();
        setState(() => _areCredentialsInvalid = true);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
