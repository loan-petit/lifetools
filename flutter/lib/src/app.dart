import 'package:flutter/material.dart';

import 'package:lifetools/src/router.dart';
import 'package:flutter/services.dart';

/// The main [Widget] containing the [MaterialApp] definition.
class App extends StatelessWidget {
  final _router = Router();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(255, 233, 68, 1),
      primaryVariant: Color.fromRGBO(255, 233, 68, 1),
      secondary: Color.fromRGBO(255, 233, 68, 1),
      secondaryVariant: Color.fromRGBO(255, 233, 68, 1),
      surface: Color.fromRGBO(3, 27, 43, 1),
      background: Color.fromRGBO(2, 24, 38, 1),
      error: Colors.red,
      onPrimary: Color.fromRGBO(56, 56, 56, 1),
      onSecondary: Color.fromRGBO(56, 56, 56, 1),
      onSurface: Color.fromRGBO(245, 245, 245, 1),
      onBackground: Color.fromRGBO(245, 245, 245, 1),
      onError: Color.fromRGBO(245, 245, 245, 1),
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorScheme.background,
    ));

    return MaterialApp(
      title: 'LifeTools',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: colorScheme.primary,
        primaryColorBrightness: Brightness.light,
        accentColor: colorScheme.secondary,
        accentColorBrightness: Brightness.light,
        cardColor: colorScheme.surface,
        canvasColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
        dialogBackgroundColor: colorScheme.background,
        backgroundColor: colorScheme.background,
        appBarTheme: AppBarTheme(color: Colors.transparent),
        primaryIconTheme: IconThemeData(color: colorScheme.onBackground),
        colorScheme: colorScheme,
        fontFamily: 'OpenSans',
        textTheme: Typography.englishLike2018.apply(
          displayColor: colorScheme.onBackground,
          bodyColor: colorScheme.onBackground,
          decorationColor: colorScheme.onBackground,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
