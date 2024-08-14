import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/di.dart';
import '../../data/repository/event_calendar_repo.dart';

@singleton
class EventCalendarImpl implements EventCalendarRepo {
  @override
  Future<void> createEventCalendar(EventCalendar eventCalendar) async {
    final IsarServices isarServices = di.get();
    await isarServices.updateData(eventCalendar);
  }
}
