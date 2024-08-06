import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_base_project/view/pages/login/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc});
}

class UnLoginEvent extends LoginEvent {
  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    yield UnLoginState();
  }
}

class LoadLoginEvent extends LoginEvent {
   
  @override
  Stream<LoginState> applyAsync(
      {LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      yield UnLoginState();
      await Future.delayed(const Duration(seconds: 1));
      yield InLoginState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState( _.toString());
    }
  }
}
