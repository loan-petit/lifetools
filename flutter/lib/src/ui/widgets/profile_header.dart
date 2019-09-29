import 'package:flutter/material.dart';

import 'package:lifetools/src/blocs/user.dart';
import 'package:lifetools/src/models/user.dart';
import 'package:lifetools/src/ui/widgets/shared/loading_screen.dart';

/// Display the profile of a user.
class ProfileHeader extends StatefulWidget {
  ProfileHeader();

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  /// Manages the business logic related to the user profile retrieval.
  final _userBloc = UserBloc();

  /// Retrieve informations on the current user.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userBloc.getCurrentUser();
  }

  /// Dispose of the [UserBloc].
  @override
  void dispose() {
    _userBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userBloc.user,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              "An error occured during the retrieval of your profile.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .apply(color: Colors.red, fontWeightDelta: 2),
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LoadingScreen(child: _buildProfileHeader(snapshot.data));
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.done:
            return _buildProfileHeader(snapshot.data);
        }
        return null; // unreachable
      },
    );
  }

  Widget _buildProfileHeader(UserModel data) {
    if (data == null) return Container();

    final userAvatar = Hero(
      tag: "avatar",
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 60.0,
        child: ClipOval(
          child: Image.asset(
            'png/default_profile_picture.png',
            fit: BoxFit.cover,
            width: 120.0,
            height: 120.0,
          ),
        ),
      ),
    );

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          userAvatar,
          SizedBox(height: 8.0),
          Text(
            "Loan PETIT",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
