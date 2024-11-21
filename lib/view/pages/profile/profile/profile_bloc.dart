import 'dart:developer' as developer;

import '../../../../index.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(super.initialState) {
    on<ProfileEvent>((event, emit) {
      return emit.forEach<ProfileState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'ProfileBloc', error: error, stackTrace: stackTrace);
          return ErrorProfileState(error.toString());
        },
      );
    });
  }
}
