import 'package:device_calendar/device_calendar.dart';
import 'package:injectable/injectable.dart';

import '../../domain/event_calendar.dart/event_calendar_model.dart';

abstract class EventCalendarRepo {
  @factoryMethod
  Future<void> createEventCalendar(
      EventCalendar eventCalendar, Calendar calendar);

  @factoryMethod
  Future<Result<String>?> createEventToCalendarDevice(
      EventCalendar eventCalendar, Calendar calendar);
}
