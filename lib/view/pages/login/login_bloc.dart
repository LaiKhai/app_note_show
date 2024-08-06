import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter_base_project/view/pages/login/index.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc(LoginState initialState) : super(initialState){
   on<LoginEvent>((event, emit) {
      return emit.forEach<LoginState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'LoginBloc', error: error, stackTrace: stackTrace);
          return ErrorLoginState(error.toString());
        },
      );
    });
  }
}
