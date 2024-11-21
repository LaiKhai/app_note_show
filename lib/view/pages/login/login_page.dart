import 'package:flutter/material.dart';

import 'index.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc(const UnLoginState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginScreen(loginBloc: _loginBloc),
    );
  }
}
