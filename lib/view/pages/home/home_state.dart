import 'package:equatable/equatable.dart';

import '../create_show_detail/index.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<dynamic> get props => [];
}

/// UnInitialized
class UnHomeState extends HomeState {
  const UnHomeState();

  @override
  String toString() => 'UnHomeState';
}

/// Initialized
class InHomeState extends HomeState {
  const InHomeState(this.lstEventCalendar, this.mergedList);

  final List<EventCalendar> lstEventCalendar;
  final List<DateTime> mergedList;

  @override
  String toString() => 'InHomeState $lstEventCalendar';

  @override
  List<dynamic> get props => [lstEventCalendar, mergedList];
}

class FilterHomeState extends HomeState {
  const FilterHomeState(this.lstEventCalendar, this.mergedList);

  final List<EventCalendar> lstEventCalendar;
  final List<DateTime> mergedList;

  @override
  String toString() => 'FilterHomeState $lstEventCalendar';

  @override
  List<Object> get props => [lstEventCalendar, mergedList];
}

class SearchTitleHomeState extends HomeState {
  const SearchTitleHomeState(this.lstEventCalendar);

  final List<EventCalendar> lstEventCalendar;

  @override
  String toString() => 'SearchTitleHomeState $lstEventCalendar';

  @override
  List<Object> get props => [lstEventCalendar];
}

class ErrorHomeState extends HomeState {
  const ErrorHomeState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorHomeState';

  @override
  List<Object> get props => [errorMessage];
}
