import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter_app/src/blocs/user.dart';
import 'package:flutter_app/src/ui/widgets/shared/app_scaffold.dart';
import 'package:flutter_app/src/ui/widgets/shared/arc_hero/index.dart';
import 'package:flutter_app/src/ui/widgets/shared/loading_screen.dart';
import 'package:flutter_app/src/utils/field_validator.dart';
import 'package:flutter_app/src/utils/graphql/graphql_exception.dart';

/// Display a [Form] to the user to retrieve his credentials and sign him in.
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  /// Create a [GlobalKey] that uniquely identifies the [Form] widget
  /// and allows its validation.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the editable email [TextFormField].
  final _email = TextEditingController();

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
    _userBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showDefaultAppBar: false,
      body: LoadingScreen(
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
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the sign in form and its widgets.
  Form _buildForm() {
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
      textInputAction: TextInputAction.go,
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

    final signInButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _signIn({'email': _email.text, 'password': _password.text});
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final errorLabel = Text(
      'Invalid email or password.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.body2.apply(color: Colors.red),
    );

    // If the user doesn't have an account he has to sign up before.
    final signUpLabel = FlatButton(
      child: Text(
        'Create an account',
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/auth/signup');
      },
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
                email,
                SizedBox(height: 24.0),
                password,
                SizedBox(height: 12.0),
                signInButton,
                if (_areCredentialsInvalid) errorLabel,
                signUpLabel,
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

  /// Sign a user in and manage UI changes before, during and after the operation.
  ///
  /// Retrieve user's [credentials] in order to send these to the [UserBloc]
  /// which will handle all the business logic needed to sign the user in.
  void _signIn(Map<String, String> credentials) async {
    if (_formKey.currentState.validate()) {
      try {
        // Hide keyboard as the form as been submitted and the user
        // has to wait for the end of the asynchronous calls.
        unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
        await _changeLoadingVisible();
        await _userBloc.signIn(credentials);
        await Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
