import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/event_calendar.dart/event_calendar_model.dart';

abstract class EventCalendarRepo {
  @factoryMethod
  Future<void> createEventCalendar(EventCalendar eventCalendar);

  @factoryMethod
  Future<void> createEventToCalendarDevice(EventCalendar eventCalendar);
}
