import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter_base_project/view/pages/calendar/index.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {

  CalendarBloc(CalendarState initialState) : super(initialState){
   on<CalendarEvent>((event, emit) {
      return emit.forEach<CalendarState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'CalendarBloc', error: error, stackTrace: stackTrace);
          return ErrorCalendarState(error.toString());
        },
      );
    });
  }
}
