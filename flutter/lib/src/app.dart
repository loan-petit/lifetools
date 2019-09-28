import 'package:flutter/material.dart';

import 'package:lifetools/src/router.dart';
import 'package:flutter/services.dart';

/// The main [Widget] containing the [MaterialApp] definition.
class App extends StatelessWidget {
  final _router = Router();

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> themeColors = {
      'babyPowder': Color.fromRGBO(252, 252, 252, 1),
      'onyx': Color.fromRGBO(56, 56, 56, 1),
      'bananaYellow': Color.fromRGBO(255, 231, 50, 1),
    };

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeColors['babyPowder'],
    ));

    return MaterialApp(
      title: 'LifeTools',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: themeColors['babyPowder'],
        primaryColor: themeColors['bananaYellow'],
        accentColor: themeColors['onyx'],
        cardColor: themeColors['babyPowder'],
        appBarTheme: AppBarTheme(color: themeColors['babyPowder']),
        fontFamily: 'OpenSans',
        textTheme: Typography.englishLike2018.apply(
          displayColor: themeColors['onyx'],
          bodyColor: themeColors['onyx'],
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
