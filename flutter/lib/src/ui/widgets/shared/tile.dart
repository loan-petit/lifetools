import 'package:flutter/material.dart';

import 'package:lifetools/src/utils/size_config.dart';

class Tile extends StatelessWidget {
  final Widget leading;
  final Widget body;
  final Widget trailing;

  const Tile({
    Key key,
    this.leading,
    @required this.body,
    this.trailing,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(
        vertical:1 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2 * SizeConfig.heightMultiplier
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLeadingLayout(context),
              _buildBodyLayout(context),
              _buildTrailingLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingLayout(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 0.3 * SizeConfig.textMultiplier,
            ),
          ),
        ),
        child: leading,
      ),
    );
  }

  Widget _buildBodyLayout(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier),
        child: body,
      ),
    );
  }

  Widget _buildTrailingLayout(BuildContext context) {
    return Expanded(
      child: UnconstrainedBox(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0.5 * SizeConfig.heightMultiplier,
            horizontal: 1 * SizeConfig.widthMultiplier,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.3 * SizeConfig.textMultiplier),
            ),
          ),
          child: trailing,
        ),
      ),
    );
  }
}
