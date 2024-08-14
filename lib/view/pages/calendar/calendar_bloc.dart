import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(super.initialState) {
    on<CalendarEvent>((event, emit) {
      return emit.forEach<CalendarState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'CalendarBloc', error: error, stackTrace: stackTrace);
          return ErrorCalendarState(error.toString());
        },
      );
    });
  }
}
