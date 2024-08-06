import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/core/gen/colors.gen.dart';
import 'package:flutter_base_project/view/res/responsive/dimen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_project/view/pages/calendar/index.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  final DateRangePickerController _controller = DateRangePickerController();
  final List<String> views = <String>['Month', 'Year', 'Decade', 'Century'];
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
            return SfDateRangePicker(
              controller: _controller,
              initialSelectedRange:
                  PickerDateRange(DateTime.now(), DateTime.now()),
              backgroundColor: ColorName.bgLight,
              selectionMode: DateRangePickerSelectionMode.range,
              selectionTextStyle: const TextStyle(color: Colors.white),
              selectionColor: ColorName.bgLight,
              startRangeSelectionColor: ColorName.bgAppBar,
              rangeSelectionColor: ColorName.colorSelectRange,
              endRangeSelectionColor: ColorName.bgAppBar,
              headerHeight: 70,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                  dayFormat: 'EE',
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(fontWeight: FontWeight.bold))),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: ColorName.colorSelectRange)),
              yearCellStyle: const DateRangePickerYearCellStyle(
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: ColorName.colorSelectRange)),
              todayHighlightColor: ColorName.colorSelectRange,
              headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: ColorName.bgAppBar,
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    letterSpacing: 5,
                    color: ColorName.white,
                  )),

              rangeTextStyle:
                  const TextStyle(color: Colors.white, fontSize: AppSize.s16),
              view: DateRangePickerView.month,
              enablePastDates: false,
              // selectableDayPredicate: (date) {
              //   if (date.day < DateTime.now().day) {
              //     return false;
              //   }
              //   return true;
              // },
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final range =
                      '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
                      // ignore: lines_longer_than_80_chars
                      ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
                  if (kDebugMode) {
                    print(">>>>>>>>>>$range");
                  }
                }
              },
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
