import 'package:device_calendar/device_calendar.dart';
import 'package:equatable/equatable.dart';

abstract class CreateShowDetailState extends Equatable {
  const CreateShowDetailState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnCreateShowDetailState extends CreateShowDetailState {
  const UnCreateShowDetailState();

  @override
  String toString() => 'UnCreateShowDetailState';
}

/// Initialized
class InCreateShowDetailState extends CreateShowDetailState {
  const InCreateShowDetailState({this.calendars});

  final List<Calendar>? calendars;

  @override
  String toString() => 'InCreateShowDetailState $calendars';

  @override
  List<Object> get props => [calendars ?? []];
}

class ErrorCreateShowDetailState extends CreateShowDetailState {
  const ErrorCreateShowDetailState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorCreateShowDetailState';

  @override
  List<Object> get props => [errorMessage];
}
