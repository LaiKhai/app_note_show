import 'dart:async';
import 'dart:developer' as developer;

import 'package:Noteshow/view/pages/create_show_detail/create_show_detail_controller.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateShowDetailEvent {
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState currentState, CreateShowDetailBloc bloc});
}

class UnCreateShowDetailEvent extends CreateShowDetailEvent {
  @override
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState? currentState,
      CreateShowDetailBloc? bloc}) async* {
    yield const UnCreateShowDetailState();
  }
}

class LoadCreateShowDetailEvent extends CreateShowDetailEvent {
  final CreateShowDetailController controller = di.get();
  @override
  Stream<CreateShowDetailState> applyAsync(
      {CreateShowDetailState? currentState,
      CreateShowDetailBloc? bloc}) async* {
    try {
      yield const UnCreateShowDetailState();
      final calendars = await controller.retrieveCalendars();
      yield InCreateShowDetailState(
          calendars: calendars
              .where((element) => element.isReadOnly == false)
              .toList());
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadCreateShowDetailEvent', error: _, stackTrace: stackTrace);
      yield ErrorCreateShowDetailState(_.toString());
    }
  }
}
