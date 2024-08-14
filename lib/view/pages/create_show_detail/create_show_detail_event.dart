import 'dart:async';
import 'dart:developer' as developer;

import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateShowDetailEvent {
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState currentState, CreateShowDetailBloc bloc});
}

class UnCreateShowDetailEvent extends CreateShowDetailEvent {
  @override
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState? currentState,
      CreateShowDetailBloc? bloc}) async* {
    yield const UnCreateShowDetailState();
  }
}

class LoadCreateShowDetailEvent extends CreateShowDetailEvent {
  @override
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState? currentState,
      CreateShowDetailBloc? bloc}) async* {
    try {
      yield const UnCreateShowDetailState();
      await Future.delayed(const Duration(seconds: 1));
      yield const InCreateShowDetailState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadCreateShowDetailEvent', error: _, stackTrace: stackTrace);
      yield ErrorCreateShowDetailState(_.toString());
    }
  }
}
