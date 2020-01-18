import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifetools/src/utils/size_config.dart';

import 'package:pedantic/pedantic.dart';

import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/index.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';
import 'package:lifetools/src/utils/field_validator.dart';
import 'package:lifetools/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to the user to retrieve his credentials and sign him in.
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable username [TextFormField].
  final _username = TextEditingController();

  /// Controller for the editable password [TextFormField].
  final _password = TextEditingController();

  /// If true, validate and update the [TextFormField] error text
  /// after every changes.
  bool _autoValidate = false;

  /// If true, display the [LoadingScreen] during asynchronous operations.
  bool _isLoadingVisible = false;

  /// If true, display a [Text] to indicate invalid credentials.
  bool _areCredentialsInvalid = false;

  /// Manages the business logic related to the user sign in.
  final _userBloc = UserBloc();

  /// Dispose of the [UserBloc].
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
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
      validator: FieldValidator.validateText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Username',
      ),
    );

    final password = TextFormField(
      obscureText: true,
      controller: _password,
      validator: FieldValidator.validatePassword,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
    );

    final signInButton = FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        _signIn({'username': _username.text, 'password': _password.text});
      },
      padding: EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        "SIGN IN",
        style: Theme.of(context).textTheme.button.apply(
              fontWeightDelta: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );

    final errorLabel = Text(
      'Invalid username or password.',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .body2
          .apply(color: Theme.of(context).colorScheme.error),
    );

    // If the user doesn't have an account he has to sign up before.
    final signUpLabel = FlatButton(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 2),
          children: <TextSpan>[
            TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign up.',
              style: Theme.of(context).textTheme.body1.apply(
                  fontWeightDelta: 2,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/auth/signup');
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
            padding: EdgeInsets.all(3 * SizeConfig.heightMultiplier),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    username,
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    password,
                    if (_areCredentialsInvalid) SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    if (_areCredentialsInvalid) errorLabel,
                    SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    signInButton,
                    SizedBox(height: 2 * SizeConfig.heightMultiplier),
                    signUpLabel,
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

  /// Sign a user in and manage UI changes before, during and after the operation.
  ///
  /// Retrieve user's [credentials] in order to send these to the [UserBloc]
  /// which will handle all the business logic needed to sign the user in.
  Future<void> _signIn(Map<String, String> credentials) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        await _userBloc.signIn(credentials);
        await Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
