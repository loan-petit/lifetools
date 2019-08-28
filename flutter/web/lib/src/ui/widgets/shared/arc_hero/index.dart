import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/ui/widgets/shared/arc_hero/arc_clipper.dart';

/// Clip an arc over the [arcContent].
///
/// It is possible to stack an [Hero] widget on the arc.
/// This widget can aligned with the [heroAlignment] property.
/// The alignment defaults to [Alignment.center].
///
/// This example shows an hero flutter logo display over an gradient content.
///
/// ```dart
/// ArcHero(
///   heroAlignment: Alignement.center,
///   hero: FlutterLogo(
///     colors: Colors.yellow,
///     size: MediaQuery.of(context).size.height / 8,
///   ),
///   arcContent: Container(
///     decoration: BoxDecoration(
///       gradient: LinearGradient(
///         begin: Alignment.topCenter,
///         end: Alignment.bottomCenter,
///         colors: <Color>[
///           Theme.of(context).primaryColor,
///           Theme.of(context).accentColor,
///         ],
///       ),
///     ),
///   ),
/// );
/// ```
class ArcHero extends StatelessWidget {
  /// Alignment of the [hero] property.
  final Alignment heroAlignment;

  /// Child of the [Hero] widget stacked on top of the background.
  final Widget hero;

  /// [Widget] used as a content for the top half arc.
  final Widget arcContent;

  ArcHero({
    this.heroAlignment = Alignment.center,
    @required this.hero,
    @required this.arcContent,
  })  : assert(hero != null),
        assert(arcContent != null);

  @override
  Widget build(BuildContext context) {
    final bottomPart = Flexible(
      flex: 1,
      child: Container(),
    );

    return Column(
      children: <Widget>[
        _buildArc(context),
        bottomPart,
      ],
    );
  }

  Widget _buildArc(BuildContext context) {
    return Flexible(
      flex: 8,
      child: ClipPath(
        clipper: ArcClipper(),
        child: Stack(
          children: <Widget>[
            arcContent,
            Align(
              alignment: heroAlignment,
              child: Hero(
                tag: 'avatar',
                child: hero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
