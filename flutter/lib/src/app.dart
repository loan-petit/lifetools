import 'package:flutter/material.dart';

import 'package:lifetools/src/router.dart';
import 'package:flutter/services.dart';
import 'package:lifetools/src/ui/app_theme.dart';
import 'package:lifetools/src/utils/size_config.dart';

/// The main [Widget] containing the [MaterialApp] definition.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.backgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            AppTheme().init();

            return MaterialApp(
              title: 'LifeTools',
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.themeData,
              initialRoute: '/',
              onGenerateRoute: Router().onGenerateRoute,
            );
          },
        );
      },
    );
  }
}
