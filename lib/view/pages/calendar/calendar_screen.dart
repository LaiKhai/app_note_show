import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_project/view/pages/calendar/index.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    required CalendarBloc calendarBloc,
    super.key,
  }) : _calendarBloc = calendarBloc;

  final CalendarBloc _calendarBloc;

  @override
  CalendarScreenState createState() {
    return CalendarScreenState();
  }
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
        bloc: widget._calendarBloc,
        builder: (
          BuildContext context,
          CalendarState currentState,
        ) {
          if (currentState is UnCalendarState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorCalendarState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InCalendarState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._calendarBloc.add(LoadCalendarEvent());
  }
}
