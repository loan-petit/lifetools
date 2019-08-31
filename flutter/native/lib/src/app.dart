import 'package:flutter/material.dart';

import 'package:flutter_app/src/router.dart';

/// The main [Widget] containing the [MaterialApp] definition.
class App extends StatelessWidget {
  final _router = Router();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color.fromRGBO(252, 252, 252, 1),
        primaryColor: Color.fromRGBO(255, 201, 97, 1),
        accentColor: Color.fromRGBO(255, 188, 58, 1),
        appBarTheme: AppBarTheme(color: Colors.transparent),
        fontFamily: 'OpenSans',
        typography: Typography(
          platform: Theme.of(context).platform,
          englishLike: Typography.englishLike2018,
          dense: Typography.dense2018,
          tall: Typography.tall2018,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
