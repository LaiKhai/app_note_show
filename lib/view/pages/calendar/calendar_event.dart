import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_base_project/view/pages/calendar/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CalendarEvent {
  Stream<CalendarState> applyAsync(
      {CalendarState currentState, CalendarBloc bloc});
}

class UnCalendarEvent extends CalendarEvent {
  @override
  Stream<CalendarState> applyAsync({CalendarState? currentState, CalendarBloc? bloc}) async* {
    yield UnCalendarState();
  }
}

class LoadCalendarEvent extends CalendarEvent {
   
  @override
  Stream<CalendarState> applyAsync(
      {CalendarState? currentState, CalendarBloc? bloc}) async* {
    try {
      yield UnCalendarState();
      await Future.delayed(const Duration(seconds: 1));
      yield InCalendarState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadCalendarEvent', error: _, stackTrace: stackTrace);
      yield ErrorCalendarState( _.toString());
    }
  }
}
