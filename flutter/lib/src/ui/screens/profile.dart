import 'package:flutter/material.dart';

import 'package:lifetools/src/ui/widgets/profile_header.dart';
import 'package:lifetools/src/ui/widgets/shared/app_scaffold.dart';
import 'package:lifetools/src/ui/widgets/shared/app_sliver_persistent_header_delegate.dart';

/// Display the profile of a user.
class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(child: ProfileHeader()),
              _buildSliverHeader(
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.history), text: "My history"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader _buildSliverHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverPersistentHeaderDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: child,
      ),
    );
  }
}
