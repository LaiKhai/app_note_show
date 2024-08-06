import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter_base_project/view/pages/home/index.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc(HomeState initialState) : super(initialState){
   on<HomeEvent>((event, emit) {
      return emit.forEach<HomeState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'HomeBloc', error: error, stackTrace: stackTrace);
          return ErrorHomeState(error.toString());
        },
      );
    });
  }
}
