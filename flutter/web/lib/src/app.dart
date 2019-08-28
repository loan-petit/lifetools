import 'package:flutter_web/material.dart';

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
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,

        // Define the default font family.
        fontFamily: 'OpenSans-Regular',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: Typography.englishLike2018,
      ),
      initialRoute: '/',
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
