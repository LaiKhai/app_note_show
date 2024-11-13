import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';

import '../../../index.dart';

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
  List<DateTime> lstBlackoutDate = [];
  CalendarScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    child: Text(AppLocalizations.of(context)!.reload),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InCalendarState) {
            lstBlackoutDate = currentState.lstDataEvent;
            return SfDateRangePicker(
              controller: _controller,
              initialSelectedRange:
                  PickerDateRange(DateTime.now(), DateTime.now()),
              backgroundColor: ColorName.bgAppBar,
              selectionMode: DateRangePickerSelectionMode.multiple,
              selectionTextStyle: const TextStyle(color: Colors.white),
              selectionColor: ColorName.colorGrey2,
              startRangeSelectionColor: ColorName.bgAppBar,
              rangeSelectionColor: ColorName.colorSelectRange,
              endRangeSelectionColor: ColorName.bgAppBar,
              headerHeight: 70,
              monthViewSettings: DateRangePickerMonthViewSettings(
                  blackoutDates: currentState.lstDataEvent,
                  dayFormat: 'EE',
                  viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(fontWeight: FontWeight.bold))),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                  blackoutDateTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: ColorName.colorGrey2),
                  blackoutDatesDecoration: BoxDecoration(
                      color: ColorName.colorGrey1, shape: BoxShape.circle),
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: ColorName.black)),
              yearCellStyle: const DateRangePickerYearCellStyle(
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: ColorName.colorSelectRange)),
              todayHighlightColor: ColorName.colorGrey2,
              headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: ColorName.bgAppBar,
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    letterSpacing: 5,
                    color: ColorName.black,
                  )),
              rangeTextStyle:
                  const TextStyle(color: Colors.white, fontSize: AppSize.s16),
              view: DateRangePickerView.month,
              enablePastDates: false,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final range =
                      '${DateFormat(Constants.DAY_FORMAT).format(args.value.startDate)} -'
                      // ignore: lines_longer_than_80_chars
                      ' ${DateFormat(Constants.DAY_FORMAT).format(args.value.endDate ?? args.value.startDate)}';
                  if (kDebugMode) {
                    print(">>>>>>>>>>$range");
                  }
                }
              },
              onSubmit: (p0) {
                if (_controller.selectedDates != null &&
                    _controller.selectedDates!.isNotEmpty) {
                  GoRouter.of(context).push(CreateShowDetailPage.routeName,
                      extra: {'controller': _controller});
                } else {
                  ScaffoldMessenger.of(navigatorKey.currentContext!)
                      .showSnackBar(
                    SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.selectDate)),
                  );
                }
              },
              onCancel: () {
                GoRouter.of(context).pushReplacement(HomePage.routeName);
              },
              confirmText: "NEXT",
              cancelText: AppLocalizations.of(context)!.cancel.toUpperCase(),
              showActionButtons: true,
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
