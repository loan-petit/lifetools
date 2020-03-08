import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/ui/widgets/shared/emphasised_text.dart';
import 'package:lifetools/src/ui/widgets/shared/scaffold/drawer.dart';
import 'package:lifetools/src/utils/size_config.dart';

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

  /// [Scaffold] body which will be wrapped.
  final Widget body;

  /// Builder for a [Scaffold.floatingActionButton].
  final WidgetBuilder floatingActionButtonBuilder;

  AppScaffold({
    this.showAppBar = true,
    this.appBar,
    this.floatingActionButtonBuilder,
    @required this.body,
  }) : assert(body != null);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar ?? (widget.showAppBar) ? _buildAppBar() : null,
      drawer: SafeArea(child: AppDrawer()),
      body: SafeArea(
        child: Container(
          margin: (!SizeConfig.isPortrait)
              ? EdgeInsets.symmetric(
                  horizontal: SizeConfig.bodyHorizontalMargin)
              : null,
          child: widget.body,
          alignment: Alignment.topCenter,
        ),
      ),
      floatingActionButton: widget.floatingActionButtonBuilder != null
          ? Container(
              child: Builder(builder: widget.floatingActionButtonBuilder),
            )
          : null,
    );
  }

  /// Create the [Scaffold]'s [AppBar].
  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        alignment: Alignment.center,
        icon: Icon(
          Icons.menu,
          size: 20 * SizeConfig.sizeMultiplier,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      title: EmphasisedText(
        text: "Life*Tools*",
        style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 2),
      ),
      elevation: 0,
    );
  }
}
