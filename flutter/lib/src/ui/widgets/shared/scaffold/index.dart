import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/drawer.dart';

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
  /// Build the scaffold's default [AppBar] using [_buildAppBar] if true.
  final bool showAppBar;

  /// Specify an [AppBar] to use instead of the default one.
  final Widget appBar;

  /// Title presented in the [AppBar].
  final String title;

  /// [Scaffold] body which will be wrapped.
  final Widget body;

  /// Builder for a [Scaffold.floatingActionButton].
  final WidgetBuilder floatingActionButtonBuilder;

  AppScaffold({
    this.showAppBar = true,
    this.appBar,
    this.title,
    this.floatingActionButtonBuilder,
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: widget.appBar ?? (widget.showAppBar) ? _buildAppBar() : null,
      drawer: SafeArea(child: AppDrawer()),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: (constraints.maxWidth > 600)
                  ? EdgeInsets.symmetric(horizontal: constraints.maxWidth / 4)
                  : null,
              child: widget.body,
              alignment: Alignment.topCenter,
            );
          },
        ),
      ),
      floatingActionButton: widget.floatingActionButtonBuilder != null
          ? Container(
              margin: EdgeInsets.only(
                  right: screenWidth > 600 ? screenWidth / 5 : 0.0),
              child: Builder(builder: widget.floatingActionButtonBuilder),
            )
          : null,
    );
  }

  /// Create the [Scaffold]'s [AppBar].
  Widget _buildAppBar() {
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      title: Container(
        margin: EdgeInsets.only(
          left: screenWidth > 600 ? screenWidth / 5 : 0.0,
        ),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 2),
            children: <TextSpan>[
              TextSpan(
                  text: (widget.title?.isNotEmpty ?? false)
                      ? widget.title
                      : 'Life'),
              if (widget.title?.isNotEmpty ?? true)
                TextSpan(
                  text: 'Tools',
                  style: Theme.of(context).textTheme.title.apply(
                      fontWeightDelta: 2,
                      color: Theme.of(context).colorScheme.primary),
                ),
            ],
          ),
        ),
      ),
      elevation: 0,
    );
  }
}
