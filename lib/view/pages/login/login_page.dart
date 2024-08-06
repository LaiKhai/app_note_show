import 'package:flutter/material.dart';
import 'package:flutter_base_project/core/gen/colors.gen.dart';
import 'package:flutter_base_project/view/pages/login/index.dart';
import 'package:flutter_base_project/view/res/responsive/dimen.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc(UnLoginState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginScreen(loginBloc: _loginBloc),
    );
  }
}
