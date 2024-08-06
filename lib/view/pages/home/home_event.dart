import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_base_project/view/pages/home/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync(
      {HomeState currentState, HomeBloc bloc});
}

class UnHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
    yield UnHomeState();
  }
}

class LoadHomeEvent extends HomeEvent {
   
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield UnHomeState();
      await Future.delayed(const Duration(seconds: 1));
      yield InHomeState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState( _.toString());
    }
  }
}
