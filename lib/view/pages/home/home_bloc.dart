import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(super.initialState) {
    on<HomeEvent>((
      event,
      emit,
    ) {
      return emit.forEach<HomeState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'HomeBloc', error: error, stackTrace: stackTrace);
          return ErrorHomeState(error.toString());
        },
      );
    });
  }
}
