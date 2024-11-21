import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnCalendarState extends CalendarState {
  const UnCalendarState();

  @override
  String toString() => 'UnCalendarState';
}

/// Initialized
class InCalendarState extends CalendarState {
  const InCalendarState(this.lstDataEvent);

  final List<DateTime> lstDataEvent;

  @override
  String toString() => 'InCalendarState $lstDataEvent';

  @override
  List<Object> get props => [lstDataEvent];
}

class ErrorCalendarState extends CalendarState {
  const ErrorCalendarState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorCalendarState';

  @override
  List<Object> get props => [errorMessage];
}
