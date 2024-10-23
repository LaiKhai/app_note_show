// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'event_calendar_model.g.dart';

@collection
class EventCalendar {
  Id id = Isar.autoIncrement;
  String? calendarId;
  String? eventId;
  String? name;
  String? local;
  String? price;
  String? decription;
  bool? isPaid;
  DateTime? startDate;
  DateTime? endDate;
  EventCalendar({
    this.id = Isar.autoIncrement,
    this.calendarId,
    this.eventId,
    this.name,
    this.local,
    this.price,
    this.decription,
    this.isPaid,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calendarId': calendarId,
      'eventId': eventId,
      'name': name,
      'local': local,
      'price': price,
      'decription': decription,
      'isPaid': isPaid,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory EventCalendar.fromMap(Map<String, dynamic> map) {
    return EventCalendar(
      id: map['id'] as int,
      calendarId: map['calendarId'] as String?,
      eventId: map['eventId'] as String?,
      name: map['name'] as String?,
      local: map['local'] as String?,
      price: map['price'] as String?,
      decription: map['decription'] as String?,
      isPaid: map['isPaid'] as bool?,
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'] as String)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventCalendar.fromJson(String source) =>
      EventCalendar.fromMap(json.decode(source) as Map<String, dynamic>);
}
