// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'event_calendar_model.g.dart';

@collection
class EventCalendar {
  Id id = Isar.autoIncrement;
  String? name;
  String? local;
  String? price;
  String? decription;
  bool? isPaid;
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime>? listDate;
  EventCalendar({
    this.id = Isar.autoIncrement,
    this.name,
    this.local,
    this.price,
    this.decription,
    this.isPaid,
    this.startDate,
    this.endDate,
    this.listDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'local': local,
      'price': price,
      'decription': decription,
      'isPaid': isPaid,
      'startDate':
          startDate?.toIso8601String(), // Chuyển đổi DateTime thành chuỗi
      'endDate': endDate?.toIso8601String(), // Chuyển đổi DateTime thành chuỗi
      'listDate': listDate
          ?.map((date) => date.toIso8601String())
          .toList(), // Chuyển đổi List<DateTime> thành danh sách chuỗi
    };
  }

  factory EventCalendar.fromMap(Map<String, dynamic> map) {
    return EventCalendar(
      id: map['id'] as int,
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
      listDate: (map['listDate'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date as String))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventCalendar.fromJson(String source) =>
      EventCalendar.fromMap(json.decode(source) as Map<String, dynamic>);
}
