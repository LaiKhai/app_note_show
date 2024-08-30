import 'package:flutter/material.dart';

import 'index.dart';

class CalendarPage extends StatefulWidget {
  static const String routeName = '/calendar';

  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final _calendarBloc = CalendarBloc(const UnCalendarState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: CalendarScreen(calendarBloc: _calendarBloc)),
    );
  }
}
