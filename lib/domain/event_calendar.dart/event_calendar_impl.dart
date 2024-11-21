import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import '../../core/di.dart';
import '../../data/repository/event_calendar_repo.dart';

@singleton
class EventCalendarImpl implements EventCalendarRepo {
  @override
  Future<void> createEventCalendar(
      EventCalendar eventCalendar, Calendar calendar) async {
    final IsarServices isarServices = di.get();
    eventCalendar.calendarId = calendar.id;
    await isarServices.updateData(eventCalendar);
  }

  @override
  Future<Result<String>?> createEventToCalendarDevice(
      EventCalendar eventCalendar, Calendar calendar) async {
    String timezone = 'Etc/UTC';
    TZDateTime? startDate;
    // TimeOfDay? startTime;

    TZDateTime? endDate;
    // TimeOfDay? endTime;
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    late Event event;
    try {
      var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          EasyLoading.showError('PERMISSION ERROR');
        }
      }

      try {
        timezone = await FlutterTimezone.getLocalTimezone();
      } catch (e) {
        debugPrint('Could not get the local timezone');
      }

      debugPrint(
          'calendar_event _timezone ------------------------- $timezone');
      final currentLocation = timeZoneDatabase.locations[timezone];

      if (currentLocation != null) {
        final eventStart =
            TZDateTime.from(eventCalendar.startDate!, currentLocation);
        final eventEnd =
            TZDateTime.from(eventCalendar.endDate!, currentLocation);

        startDate = eventStart;
        // startTime = TimeOfDay(hour: eventStart.hour, minute: eventStart.minute);

        endDate = eventEnd;
        // endTime = TimeOfDay(hour: eventEnd.hour, minute: eventEnd.minute);
      } else {
        var fallbackLocation = timeZoneDatabase.locations['Asia/Ho_Chi_Minh'];
        final eventStart =
            TZDateTime.from(eventCalendar.startDate!, fallbackLocation!);
        final eventEnd =
            TZDateTime.from(eventCalendar.endDate!, fallbackLocation);

        startDate = eventStart;
        // startTime = TimeOfDay(hour: eventStart.hour, minute: eventStart.minute);

        endDate = eventEnd;
        // endTime = TimeOfDay(hour: eventEnd.hour, minute: eventEnd.minute);
      }

      event = Event(
        calendar.id,
        title: eventCalendar.name,
        description: eventCalendar.decription,
        reminders: [Reminder(minutes: 30)],
        start: startDate,
        end: endDate,
      );

      debugPrint('DeviceCalendarPlugin calendar id is: ${calendar.id}');

      eventCalendar.calendarId = calendar.id;

      final dataEvent = await deviceCalendarPlugin.createOrUpdateEvent(event);

      final eventData = await deviceCalendarPlugin.retrieveEvents(calendar.id,
          RetrieveEventsParams(startDate: startDate, endDate: endDate));
      debugPrint("$eventData");
      eventCalendar.eventId = dataEvent?.data ?? "";

      createEventCalendar(eventCalendar, calendar);

      return dataEvent;
    } on PlatformException catch (e) {
      EasyLoading.showError('$e');
    }
    return Result();
  }
}
