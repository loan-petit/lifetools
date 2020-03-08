import 'package:flutter/material.dart';
import 'package:lifetools/src/utils/size_config.dart';

/// Drawer for application triggered by click on the [AppBar] menu button.
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final header = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 2),
        children: <TextSpan>[
          TextSpan(text: 'Life'),
          TextSpan(
            text: 'Tools',
            style: Theme.of(context).textTheme.title.apply(
                fontWeightDelta: 2,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );

    Widget logoutButton = FlatButton(
      child: Text(
        "LOG OUT",
        style: Theme.of(context).textTheme.button.apply(
              fontWeightDelta: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/auth/signout');
      },
    );

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 15 * SizeConfig.sizeMultiplier),
          header,
          SizedBox(height: 25 * SizeConfig.sizeMultiplier),
          buildMenuItem(
              context, Icons.timelapse, 'Daily Routine', '/daily-routine'),
          SizedBox(height: 15 * SizeConfig.sizeMultiplier),
          buildMenuItem(context, Icons.work, 'Goals', '/goals'),
          SizedBox(height: 25 * SizeConfig.sizeMultiplier),
          logoutButton,
        ],
      ),
    );
  }

  Widget buildMenuItem(
      BuildContext context, IconData icon, String title, String namedRoute) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, namedRoute);
      },
      child: Container(
        height: 48.0,
        padding: EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 6.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(flex: 1, child: Icon(icon)),
            Flexible(
              flex: 8,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
