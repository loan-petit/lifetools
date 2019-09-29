import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
        Navigator.pushReplacementNamed(context, '/logout');
      },
    );

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 16.0),
          header,
          SizedBox(height: 32.0),
          buildMenuItem(Icons.account_circle, 'Profile', '/profile'),
          SizedBox(height: 8.0),
          buildMenuItem(Icons.work, 'Goals & Events', '/goals-events'),
          SizedBox(height: 8.0),
          buildMenuItem(Icons.timelapse, 'Daily Routine', '/daily-routine'),
          SizedBox(height: 32.0),
          logoutButton,
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, namedRoute) {
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
                color: Theme.of(context).colorScheme.primary, width: 8.0),
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
