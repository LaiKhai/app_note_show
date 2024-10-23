import 'dart:async';
import 'dart:developer' as developer;

import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';

import '../home/index.dart';
import 'index.dart';

@immutable
abstract class CalendarEvent {
  Stream<CalendarState> applyAsync(
      {CalendarState currentState, CalendarBloc bloc});
}

class UnCalendarEvent extends CalendarEvent {
  @override
  Stream<CalendarState> applyAsync(
      {CalendarState? currentState, CalendarBloc? bloc}) async* {
    yield const UnCalendarState();
  }
}

class LoadCalendarEvent extends CalendarEvent {
  final IsarServices isarServices = di.get();
  @override
  Stream<CalendarState> applyAsync(
      {CalendarState? currentState, CalendarBloc? bloc}) async* {
    try {
      yield const UnCalendarState();
      final listEvent = await isarServices.getAllData();
      List<DateTime> mergedList = groupDateTime(listEvent);

      yield InCalendarState(mergedList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadCalendarEvent', error: _, stackTrace: stackTrace);
      yield ErrorCalendarState(_.toString());
    }
  }
}
