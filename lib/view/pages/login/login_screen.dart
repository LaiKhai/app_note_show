import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/gen/colors.gen.dart';
import '../../res/responsive/dimen.dart';
import 'index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required LoginBloc loginBloc,
    super.key,
  }) : _loginBloc = loginBloc;

  final LoginBloc _loginBloc;

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        bloc: widget._loginBloc,
        builder: (
          BuildContext context,
          LoginState currentState,
        ) {
          if (currentState is UnLoginState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorLoginState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InLoginState) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //TODO: logo app
                    const Padding(
                      padding: EdgeInsets.only(top: AppPadding.p8),
                      child: Text(
                        'NOTESHOW',
                        style: TextStyle(
                            fontSize: 40,
                            color: ColorName.bgAppBar,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(AppPadding.p4),
                      child: Text(
                        'Let me keep the wonderful things',
                        style: TextStyle(
                          fontSize: AppPadding.p16,
                          color: ColorName.black,
                        ),
                      ),
                    ),
                    //TODO: Login Form
                    TextField(
                      cursorColor: ColorName.colorGrey2,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorName.colorGrey1, width: 0.0),
                          ),
                          fillColor: ColorName.colorGrey1,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorName.colorGrey1, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: 'Email or number phone ',
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Assets.images.loginIcon.svg(
                                  colorFilter: const ColorFilter.mode(
                                      ColorName.colorGrey1, BlendMode.srcIn)))),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._loginBloc.add(LoadLoginEvent());
  }
}
