import 'package:flutter/material.dart';

/// Loading screen presented on top of a widget during asynchronous calls.
class LoadingScreen extends StatelessWidget {
  final double width;
  final double height;

  /// By default, on construction, we consider the app as in an asynchronous
  /// call. To change this behaviour or flag the asynchronous call as done
  /// and hide the loading screen, set this property to false.
  final bool isInAsyncCall;

  /// The widget below this widget in the tree.
  /// It will be covered by this [Widget].
  /// This widget can only have one child.
  final Widget child;

  LoadingScreen({
    Key key,
    this.width,
    this.height,
    this.isInAsyncCall = true,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  /// Build the widget by stacking the loading screen on the [child].
  @override
  Widget build(BuildContext context) {
    if (isInAsyncCall) {
      return Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            child,
            Opacity(
              child: ModalBarrier(dismissible: false, color: Colors.white),
              opacity: 0.7,
            ),
            Center(child: CircularProgressIndicator())
          ],
        ),
      );
    }

    return child;
  }
}
