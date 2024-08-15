import 'package:flutter/material.dart';
import 'package:Noteshow/view/pages/profile/profile/index.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileBloc = ProfileBloc(UnProfileState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ProfileScreen(profileBloc: _profileBloc),
    );
  }
}
