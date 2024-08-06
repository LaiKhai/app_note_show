import 'package:flutter/material.dart';
import 'package:flutter_base_project/view/pages/calendar/index.dart';

class CalendarPage extends StatefulWidget {
  static const String routeName = '/calendar';

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _calendarBloc = CalendarBloc(UnCalendarState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: CalendarScreen(calendarBloc: _calendarBloc),
    );
  }
}
