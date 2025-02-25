import 'dart:async';
import 'dart:developer' as developer;

import 'package:Noteshow/index.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync({HomeState currentState, HomeBloc bloc});
}

class UnHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    yield const UnHomeState();
  }
}

class LoadHomeEvent extends HomeEvent {
  final IsarServices isarServices = di.get();
  final NotesEnum status;

  LoadHomeEvent({this.status = NotesEnum.ALL});

  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      List<EventCalendar> lstEventCalendar = [];
      yield const UnHomeState();
      switch (status) {
        case NotesEnum.ALL:
          {
            lstEventCalendar = await isarServices.getAllData();
            break;
          }
        case NotesEnum.PAID:
          {
            lstEventCalendar = await isarServices.getPaidData();
            break;
          }
        case NotesEnum.UNPAID:
          {
            lstEventCalendar = await isarServices.getUnPaidData();
            break;
          }
        case NotesEnum.OVERDUE:
          {
            lstEventCalendar = await isarServices.getOverdueData();
            break;
          }
        default:
          {
            lstEventCalendar = await isarServices.getAllData();
            break;
          }
      }

      List<DateTime> mergedList = groupDateTime(lstEventCalendar);
      yield InHomeState(lstEventCalendar, mergedList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class DeleteDataEvent extends HomeEvent {
  final IsarServices isarServices = di.get();
  final int dataId;
  DeleteDataEvent({required this.dataId});
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield const UnHomeState();
      await isarServices.deleteData(dataId);
      final lstEventCalendar = await isarServices.getAllData();
      List<DateTime> mergedList = groupDateTime(lstEventCalendar);
      yield InHomeState(lstEventCalendar, mergedList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class UpdatePaidDataEvent extends HomeEvent {
  final IsarServices isarServices = di.get();
  final EventCalendar event;
  UpdatePaidDataEvent({required this.event});
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield const UnHomeState();
      await isarServices.updateData(event);
      final lstEventCalendar = await isarServices.getAllData();
      List<DateTime> mergedList = groupDateTime(lstEventCalendar);
      yield InHomeState(lstEventCalendar, mergedList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class FilterDateTimeDataEvent extends HomeEvent {
  final IsarServices isarServices = di.get();
  final DateTime startDate;
  final DateTime endDate;
  FilterDateTimeDataEvent(this.startDate, this.endDate);
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield const UnHomeState();
      final lstfilterCalendar =
          await isarServices.filterDateTime(startDate, endDate);
      final lstEventCalendar = await isarServices.getAllData();
      List<DateTime> mergedList = groupDateTime(lstEventCalendar);
      yield FilterHomeState(lstfilterCalendar, mergedList);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class SearchDataEvent extends HomeEvent {
  final IsarServices isarServices = di.get();
  final String title;
  SearchDataEvent(this.title);
  @override
  Stream<HomeState> applyAsync(
      {HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield const UnHomeState();
      final lstfilterCalendar = await isarServices.searchTitleEvent(title);
      yield SearchTitleHomeState(lstfilterCalendar);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

List<DateTime> groupDateTime(List<EventCalendar> lstEventCalendar) {
  return lstEventCalendar
      .expand((event) {
        if (event.startDate != null && event.endDate != null) {
          return List.generate(
            event.endDate!.difference(event.startDate!).inDays + 1,
            (index) => event.startDate!.add(Duration(days: index)),
          );
        } else {
          return <DateTime>[];
        }
      })
      .toSet()
      .toList()
    ..sort();
}
