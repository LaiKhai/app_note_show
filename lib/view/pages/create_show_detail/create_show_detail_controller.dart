import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

@LazySingleton()
class CreateShowDetailController {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<List<Calendar>> retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return [];
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      return calendarsResult.data as List<Calendar>;
    } on PlatformException catch (e, s) {
      debugPrint('RETRIEVE_CALENDARS: $e, $s');
    }
    return [];
  }

  Future<void> createEventCalendar(
    BuildContext context,
    EventCalendarImpl eventCalendarImpl,
    List<GlobalKey<FormState>> formKeys,
    int index,
    Calendar calendar,
    Function(List<DateTime>?) callBack, {
    List<DateTime>? listSelectTime,
    String? name,
    String? price,
    String? decription,
    DateTime? startDate,
    DateTime? endDate,
    List<FocusNode>? titleFocusNode,
    List<FocusNode>? priceFocusNode,
    List<FocusNode>? decriptionFocusNode,
    List<TextEditingController>? titleController,
    List<TextEditingController>? priceController,
    List<TextEditingController>? decriptionController,
  }) async {
    if (formKeys[index].currentState!.validate()) {
      // Validate returns true if the form is valid, or false otherwise.\
      final eventCalendar = EventCalendar(
          name: name,
          price: price,
          decription: decription,
          startDate: startDate,
          endDate: endDate,
          isPaid: false);

      final createEventDevice = await eventCalendarImpl
          .createEventToCalendarDevice(eventCalendar, calendar);
      if (createEventDevice?.isSuccess ?? false) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.senDataSuccessfull),
          ),
        );

        _removeEvent(index,
            listSelectTime: listSelectTime,
            titleFocusNode: titleFocusNode,
            priceFocusNode: priceFocusNode,
            decriptionFocusNode: decriptionFocusNode,
            titleController: titleController,
            priceController: priceController,
            decriptionController: decriptionController);
      }
      callBack(listSelectTime);
    }
  }

  void _removeEvent(
    int index, {
    List<DateTime>? listSelectTime,
    List<FocusNode>? titleFocusNode,
    List<FocusNode>? priceFocusNode,
    List<FocusNode>? decriptionFocusNode,
    List<TextEditingController>? titleController,
    List<TextEditingController>? priceController,
    List<TextEditingController>? decriptionController,
  }) {
    // Remove the corresponding elements
    listSelectTime?.removeAt(index);

    titleController?[index].dispose();
    priceController?[index].dispose();
    decriptionController?[index].dispose();
    titleController?.removeAt(index);
    priceController?.removeAt(index);
    decriptionController?.removeAt(index);

    titleFocusNode?[index].dispose();
    priceFocusNode?[index].dispose();
    decriptionFocusNode?[index].dispose();
    titleFocusNode?.removeAt(index);
    priceFocusNode?.removeAt(index);
    decriptionFocusNode?.removeAt(index);

    // Check if list is empty
    if (listSelectTime!.isEmpty) {
      GoRouter.of(navigatorKey.currentContext!)
          .pushReplacement(HomePage.routeName);
    }
  }

  Future<void> selectTime(
      BuildContext context,
      int index,
      bool isStart,
      Function(
        DateTime? startTime,
        DateTime? endTime,
      ) selectTimeCallBack,
      {DateTime? startTime,
      DateTime? endTime,
      DateTime? selectedDates}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDates!),
    );

    if (picked != null) {
      final selectedDate = DateTime(
        selectedDates.year,
        selectedDates.month,
        selectedDates.day,
        picked.hour,
        picked.minute,
      );

      // Get the current time for comparison
      final now = DateTime.now();
      final currentDate =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      // Check if the selected date is today
      if (selectedDate.isBefore(currentDate) &&
          selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day) {
        startTime = DateTime.now().add(const Duration(minutes: 30));
        endTime = startTime.add(const Duration(hours: 1));
        if (!context.mounted) return;
        // Show error message if the selected time is earlier than the current time today
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.selectDayLaterCurrentDay),
          ),
        );
        return; // Exit the function early
      }

      if (isStart) {
        // Update startTime at the given index
        startTime = selectedDate;

        // If endTime exists and is earlier than startTime, reset endTime
        if (endTime!.isBefore(startTime)) {
          endTime = startTime.add(const Duration(hours: 1));
        }
      } else {
        // If endTime is earlier than startTime, show an error and reset endTime
        if (selectedDate.isBefore(startTime!)) {
          endTime = startTime.add(const Duration(hours: 1));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.endTimeEarlyStartTime),
            ),
          );
        } else {
          // Update endTime at the given index
          endTime = selectedDate;
        }
      }

      selectTimeCallBack(startTime, endTime);
    }
  }

  void load(CreateShowDetailBloc createShowDetailBloc) {
    createShowDetailBloc.add(LoadCreateShowDetailEvent());
  }
}
