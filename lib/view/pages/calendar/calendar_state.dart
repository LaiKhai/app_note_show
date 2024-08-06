import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  CalendarState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnCalendarState extends CalendarState {

  UnCalendarState();

  @override
  String toString() => 'UnCalendarState';
}

/// Initialized
class InCalendarState extends CalendarState {
  InCalendarState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InCalendarState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorCalendarState extends CalendarState {
  ErrorCalendarState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorCalendarState';

  @override
  List<Object> get props => [errorMessage];
}
