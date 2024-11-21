import 'dart:async';
import 'dart:developer' as developer;

import 'package:meta/meta.dart';

import 'package:Noteshow/view/pages/profile/profile/index.dart';

@immutable
abstract class ProfileEvent {
  Stream<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc});
}

class UnProfileEvent extends ProfileEvent {
  @override
  Stream<ProfileState> applyAsync(
      {ProfileState? currentState, ProfileBloc? bloc}) async* {
    yield const UnProfileState();
  }
}

class LoadProfileEvent extends ProfileEvent {
  @override
  Stream<ProfileState> applyAsync(
      {ProfileState? currentState, ProfileBloc? bloc}) async* {
    try {
      yield const UnProfileState();
      await Future.delayed(const Duration(seconds: 1));
      yield const InProfileState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadProfileEvent', error: _, stackTrace: stackTrace);
      yield ErrorProfileState(_.toString());
    }
  }
}
