import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/di.dart';
import '../../data/repository/event_calendar_repo.dart';

@singleton
class EventCalendarImpl implements EventCalendarRepo {
  @override
  Future<void> createEventCalendar(EventCalendar eventCalendar) async {
    final IsarServices isarServices = di.get();
    await isarServices.updateData(eventCalendar);
  }

  @override
  Future<void> createEventToCalendarDevice(EventCalendar eventCalendar) async {
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

    var status = await Permission.calendarFullAccess.request();
    if (status.isGranted) {
      var calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
      var calendars = calendarsResult.data;

      if (calendars != null && calendars.isNotEmpty) {
        // Chọn lịch đầu tiên để thêm sự kiện
        var calendar = calendars.first;

        final tzStartTime =
            tz.TZDateTime.from(eventCalendar.startDate!, tz.local);
        final tzEndTime = tz.TZDateTime.from(eventCalendar.endDate!, tz.local);
        var event = Event(
          calendar.id,
          title: eventCalendar.name,
          description: eventCalendar.decription,
          start: tzStartTime,
          end: tzEndTime,
        );

        await deviceCalendarPlugin.createOrUpdateEvent(event);
      }
    } else {
      // Quyền bị từ chối
    }

    // Lấy danh sách các lịch có sẵn
  }
}
