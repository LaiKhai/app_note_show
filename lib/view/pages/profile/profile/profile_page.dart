import 'package:flutter/material.dart';
import 'package:Noteshow/view/pages/profile/profile/index.dart';

import '../../../../index.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _profileBloc = ProfileBloc(UnProfileState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: ProfileScreen(profileBloc: _profileBloc),
    );
  }
}
