import 'package:flutter/material.dart';

/// Emphasis parts of the [text] contained in '*' characters with the [textStyle].
class EmphasisedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;

  EmphasisedText({
    this.text,
    this.textAlign,
    this.style,
  })  : assert(text != null),
        assert(style != null);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: (this.textAlign != null) ? this.textAlign : TextAlign.center,
      text: TextSpan(
        style: this.style,
        children: _getSpans(context),
      ),
    );
  }

  /// Create a list of [TextSpan] for each part of the text.
  List<TextSpan> _getSpans(BuildContext context) {
    List<TextSpan> spans = [];
    String tmp = this.text;

    while (true) {
      final int startIndex = tmp.indexOf('*');
      final int endIndex =
          startIndex + 1 + tmp.substring(startIndex + 1).indexOf("*");

      if (startIndex != -1 && endIndex != -1) {
        spans.add(
          _buildTextSpan(context, tmp.substring(0, startIndex), false),
        );
        spans.add(
          _buildTextSpan(
              context, tmp.substring(startIndex + 1, endIndex), true),
        );
      } else {
        spans.add(_buildTextSpan(context, tmp, false));
        return spans;
      }
      tmp = tmp.substring(endIndex + 1);
    }
  }

  /// Build a [TextSpan] based on its status.
  ///
  /// If [isEmphasised] is True, the [text] with be colored with the primary color.
  TextSpan _buildTextSpan(
    BuildContext context,
    String text,
    bool isEmphasised,
  ) {
    return TextSpan(
      text: text,
      style: (isEmphasised)
          ? this.style.apply(color: Theme.of(context).colorScheme.primary)
          : this.style,
    );
  }
}
