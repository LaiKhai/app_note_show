import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:Noteshow/view/pages/profile/profile/index.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc(ProfileState initialState) : super(initialState){
   on<ProfileEvent>((event, emit) {
      return emit.forEach<ProfileState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'ProfileBloc', error: error, stackTrace: stackTrace);
          return ErrorProfileState(error.toString());
        },
      );
    });
  }
}
