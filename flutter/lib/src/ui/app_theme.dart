import 'package:flutter/material.dart';

import 'package:lifetools/src/utils/size_config.dart';

/// Definition of the application theme and styling.
class AppTheme {
  static const Brightness brightness = Brightness.dark;

  static const Color primaryColor = Color.fromRGBO(255, 233, 68, 1);
  static const Color surfaceColor = Color.fromRGBO(3, 27, 43, 1);
  static const Color backgroundColor = Color.fromRGBO(2, 24, 38, 1);
  static const Color onPrimaryColor = Color.fromRGBO(56, 56, 56, 1);
  static const Color onBackgroundColor = Color.fromRGBO(245, 245, 245, 1);

  static const _colorScheme = ColorScheme(
    brightness: brightness,
    primary: primaryColor,
    primaryVariant: primaryColor,
    secondary: primaryColor,
    secondaryVariant: primaryColor,
    surface: surfaceColor,
    background: backgroundColor,
    error: Colors.red,
    onPrimary: onPrimaryColor,
    onSecondary: onPrimaryColor,
    onSurface: onBackgroundColor,
    onBackground: onBackgroundColor,
    onError: onBackgroundColor,
  );

  static TextTheme _englishLike2018 = Typography.englishLike2018.apply(
    fontFamily: 'OpenSans',
    displayColor: onBackgroundColor,
    bodyColor: onBackgroundColor,
    decorationColor: onBackgroundColor,
  );

  static ThemeData themeData = ThemeData.from(
    colorScheme: _colorScheme,
    textTheme: _englishLike2018,
  ).copyWith(
    appBarTheme: AppBarTheme(
      color: _colorScheme.background,
      brightness: brightness,
    ),
  );

  /// Initialize the theme based on the current [SizeConfig].
  void init() {
    _englishLike2018 = Typography.englishLike2018.apply(
      fontFamily: 'OpenSans',
      fontSizeFactor: 0.125 * SizeConfig.textMultiplier,
      displayColor: onBackgroundColor,
      bodyColor: onBackgroundColor,
      decorationColor: onBackgroundColor,
    );

    themeData = ThemeData.from(
      colorScheme: _colorScheme,
      textTheme: _englishLike2018,
    ).copyWith(
      appBarTheme: AppBarTheme(
        color: _colorScheme.background,
        brightness: brightness,
      ),
    );
  }
}
