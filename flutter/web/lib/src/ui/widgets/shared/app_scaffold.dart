import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/blocs/user_bloc.dart';

/// Wrapper around [Scaffold] used as screen UI base.
///
/// This example shows a simple [body] wrapped by the [AppScaffold] and the provided [title].
///
/// ```dart
/// AppScaffold(
///   title: 'Simple Page',
///   body: Center(
///     child: Text("Hello World"),
///   ),
/// )
/// ```
class AppScaffold extends StatefulWidget {
  /// Build the scaffold's [AppBar] if true.
  final bool showAppBar;

  /// Title presented in the [AppBar].
  final String title;

  /// [Scaffold] body which will be wrapped.
  final Widget body;

  AppScaffold({
    this.showAppBar = true,
    this.title,
    @required this.body,
  }) : assert(body != null);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  /// Build the scaffold based on the widget properties and wrap the body
  /// with the UI base.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.showAppBar) ? _buildAppBar() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: (constraints.maxWidth > 600)
                ? EdgeInsets.symmetric(horizontal: constraints.maxWidth / 5)
                : null,
            color: Colors.white,
            child: widget.body,
            alignment: Alignment.topCenter,
          );
        },
      ),
    );
  }

  /// Create the [Scaffold]'s [AppBar].
  Widget _buildAppBar() {
    return AppBar(
      title: (widget.title?.isEmpty ?? false) ? Text(widget.title) : null,
      elevation: 0,
      actions: <Widget>[
        if (UserBloc.isLoggedIn)
          IconButton(
            icon: Icon(Icons.power_settings_new),
            tooltip: 'Se déconnecter',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/auth/signout', (_) => false);
            },
          ),
      ],
    );
  }
}
