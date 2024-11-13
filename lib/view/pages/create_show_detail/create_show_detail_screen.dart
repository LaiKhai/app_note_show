import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../index.dart';

class CreateShowDetailScreen extends StatefulWidget {
  const CreateShowDetailScreen({
    required CreateShowDetailBloc createShowDetailBloc,
    super.key,
    required this.controller,
  }) : _createShowDetailBloc = createShowDetailBloc;

  final CreateShowDetailBloc _createShowDetailBloc;
  final DateRangePickerController controller;
  @override
  CreateShowDetailScreenState createState() {
    return CreateShowDetailScreenState();
  }
}

class CreateShowDetailScreenState extends State<CreateShowDetailScreen> {
  final EventCalendarImpl eventCalendarImpl = di.get();

  late final List<GlobalKey<FormState>> _formKeys;
  late final List<FocusNode> titleFocusNode;
  late final List<FocusNode> priceFocusNode;
  late final List<FocusNode> decriptionFocusNode;
  late final List<TextEditingController> titleController;
  late final List<TextEditingController> priceController;
  late final List<TextEditingController> decriptionController;
  final TextEditingController calendarController = TextEditingController();
  late final List<DateTime>? startTime;
  late final List<DateTime>? endTime;

  List<DateTime>? listSelectTime = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  Calendar calendar = Calendar();

  @override
  void initState() {
    super.initState();
    initialVariable();
    _load();
  }

  void initialVariable() {
    if (widget.controller.selectedDates != null) {
      listSelectTime = widget.controller.selectedDates ?? [];
      listSelectTime?.sort();
      _formKeys = List.generate(
          listSelectTime!.length, (index) => GlobalKey<FormState>());
      titleFocusNode =
          List.generate(listSelectTime!.length, (index) => FocusNode());
      priceFocusNode =
          List.generate(listSelectTime!.length, (index) => FocusNode());
      decriptionFocusNode =
          List.generate(listSelectTime!.length, (index) => FocusNode());
      titleController = List.generate(
          listSelectTime!.length, (index) => TextEditingController());
      priceController = List.generate(
          listSelectTime!.length, (index) => TextEditingController());
      decriptionController = List.generate(
          listSelectTime!.length, (index) => TextEditingController());
      startTime = widget.controller.selectedDates!.map((date) {
        final now = DateTime.now();
        return DateTime(
                date.year,
                date.month,
                date.day,
                now.hour, // Current hour
                now.minute // Current minute
                )
            .add(const Duration(minutes: 30));
      }).toList();

      endTime =
          startTime!.map((date) => date.add(const Duration(hours: 1))).toList();
    }
  }

  @override
  void dispose() {
    for (var element in titleController) {
      element.dispose();
    }
    for (var element2 in priceController) {
      element2.dispose();
    }
    for (var element3 in decriptionController) {
      element3.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShowDetailBloc, CreateShowDetailState>(
        bloc: widget._createShowDetailBloc,
        builder: (
          BuildContext context,
          CreateShowDetailState currentState,
        ) {
          if (currentState is UnCreateShowDetailState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorCreateShowDetailState) {
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
          if (currentState is InCreateShowDetailState) {
            if (currentState.calendars != null) {
              calendar = currentState.calendars!.first;
            }
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return (listSelectTime == null || listSelectTime!.isEmpty)
                    ? Center(
                        child: EmptyPage(
                          bodyText: AppLocalizations.of(context)!.pageEmpty,
                          onPressedText:
                              AppLocalizations.of(context)!.backToCalendar,
                          onPressed: () {
                            try {
                              GoRouter.of(navigatorKey.currentContext!).pop();
                            } on PlatformException catch (e) {
                              debugPrint("$e");
                            }
                          },
                        ),
                      )
                    : ListView.builder(
                        itemCount: listSelectTime!.length,
                        itemBuilder: (context, index) => Card(
                          key: ValueKey(listSelectTime![index]),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (titleFocusNode[index].hasFocus ||
                                    priceFocusNode[index].hasFocus ||
                                    decriptionFocusNode[index].hasFocus) {
                                  titleFocusNode[index].unfocus();
                                  priceFocusNode[index].unfocus();
                                  decriptionFocusNode[index].unfocus();
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSize.s16),
                              child: Form(
                                key: _formKeys[index],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TODO: title
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        controller: titleController[index],
                                        focusNode: titleFocusNode[index],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .enterSomeText;
                                          }
                                          return null;
                                        },
                                        autofillHints: const [
                                          AutofillHints.username
                                        ],
                                        decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .titleEvent,
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: ColorName.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.s8))),
                                      ),
                                    ),
                                    //TODO: prices
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        controller: priceController[index],
                                        focusNode: priceFocusNode[index],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .enterPrices;
                                          }
                                          return null;
                                        },
                                        autofillHints: const [
                                          AutofillHints.username
                                        ],
                                        inputFormatters: [
                                          CurrencyInputFormatter(
                                              thousandSeparator:
                                                  ThousandSeparator.Period,
                                              mantissaLength: 0,
                                              trailingSymbol: 'đ')
                                        ],

                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .pricesEvent,
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: ColorName.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.s8))),
                                      ),
                                    ),

                                    // //TODO: Select calendar
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: DropdownMenu<Calendar>(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        initialSelection:
                                            currentState.calendars!.first,
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        controller: calendarController,
                                        requestFocusOnTap: false,
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .typeEvent),
                                        onSelected: (Calendar? value) {
                                          setState(() {
                                            calendar = value ??
                                                currentState.calendars!.first;
                                          });
                                        },
                                        dropdownMenuEntries: currentState
                                            .calendars!
                                            .map<DropdownMenuEntry<Calendar>>(
                                                (Calendar calendar) {
                                          return DropdownMenuEntry<Calendar>(
                                            value: calendar,
                                            label: calendar.name ?? "",
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    //TODO: date time
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s8),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .startTimeEvent,
                                        style: const TextStyle(
                                            color: ColorName.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),

                                    //TODO: date time
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              // The validator receives the text that the user has entered.

                                              enabled: false,
                                              autofillHints: const [
                                                AutofillHints.username
                                              ],
                                              decoration: InputDecoration(
                                                  hintText: DateFormat(
                                                          Constants.DAY_FORMAT)
                                                      .format(widget.controller
                                                              .selectedDates![
                                                          index]),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: ColorName.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppSize.s8))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSize.s8),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  await _selectTime(startTime,
                                                      context, index, true);
                                                },
                                                child: Container(
                                                  // margin: const EdgeInsets.all(15.0),
                                                  height: 55,
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              ColorName.black)),
                                                  child: Center(
                                                    child: Text(
                                                      DateFormat(Constants
                                                              .HOUR_FORMAT)
                                                          .format(startTime![
                                                              index]),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(width: AppSize.s10),
                                        ],
                                      ),
                                    ),
                                    //TODO: end date time
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s8),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .endTimeEvent,
                                        style: const TextStyle(
                                            color: ColorName.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),

                                    //TODO: end date time
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              // The validator receives the text that the user has entered.

                                              enabled: false,
                                              autofillHints: const [
                                                AutofillHints.username
                                              ],
                                              decoration: InputDecoration(
                                                  hintText: DateFormat(
                                                          Constants.DAY_FORMAT)
                                                      .format(widget.controller
                                                              .selectedDates![
                                                          index]),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: ColorName.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppSize.s8))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSize.s8),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  await _selectTime(endTime,
                                                      context, index, false);
                                                },
                                                child: Container(
                                                  // margin: const EdgeInsets.all(15.0),
                                                  height: 55,
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              ColorName.black)),
                                                  child: Center(
                                                    child: Text(
                                                      DateFormat(Constants
                                                              .HOUR_FORMAT)
                                                          .format(
                                                              endTime![index]),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(width: AppSize.s10),
                                        ],
                                      ),
                                    ),

                                    //TODO: decription
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s8),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .decriptionEvent,
                                        style: const TextStyle(
                                            color: ColorName.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSize.s16),
                                      child: TextFormField(
                                        controller: decriptionController[index],
                                        focusNode: decriptionFocusNode[index],
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 10,
                                        autofillHints: const [
                                          AutofillHints.username
                                        ],
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: ColorName.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.s8))),
                                      ),
                                    ),
                                    //TODO: button submit
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorName
                                                        .bgAppBar,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    AppSize
                                                                        .s8))),
                                                onPressed: () async {
                                                  await _createEventCalendar(
                                                      index, calendar);
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .createEvent,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorName.colorGrey2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorName
                                                        .bgTagUnPaid,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    AppSize
                                                                        .s8))),
                                                onPressed: () async {
                                                  setState(() {
                                                    listSelectTime
                                                        ?.removeAt(index);
                                                  });
                                                  if (listSelectTime!.isEmpty) {
                                                    GoRouter.of(navigatorKey
                                                            .currentContext!)
                                                        .pushReplacement(
                                                            HomePage.routeName);
                                                  }
                                                },
                                                child: const Center(
                                                    child: Icon(
                                                  Icons.delete,
                                                  color: ColorName.white,
                                                ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<void> _createEventCalendar(int index, Calendar calendar) async {
    if (_formKeys[index].currentState!.validate()) {
      // Validate returns true if the form is valid, or false otherwise.\
      final eventCalendar = EventCalendar(
          name: titleController[index].text,
          price: priceController[index].text,
          decription: decriptionController[index].text,
          startDate: startTime != null ? startTime![index] : DateTime.now(),
          endDate: endTime != null ? endTime![index] : DateTime.now(),
          isPaid: false);

      final createEventDevice = await eventCalendarImpl
          .createEventToCalendarDevice(eventCalendar, calendar);
      if (createEventDevice?.isSuccess ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.senDataSuccessfull),
          ),
        );
        _removeEvent(index);
      }
    }
  }

  void _removeEvent(int index) {
    setState(() {
      // Remove the corresponding elements
      listSelectTime?.removeAt(index);

      titleController[index].dispose();
      priceController[index].dispose();
      decriptionController[index].dispose();
      titleController.removeAt(index);
      priceController.removeAt(index);
      decriptionController.removeAt(index);

      titleFocusNode[index].dispose();
      priceFocusNode[index].dispose();
      decriptionFocusNode[index].dispose();
      titleFocusNode.removeAt(index);
      priceFocusNode.removeAt(index);
      decriptionFocusNode.removeAt(index);
    });

    // Check if list is empty
    if (listSelectTime!.isEmpty) {
      GoRouter.of(navigatorKey.currentContext!)
          .pushReplacement(HomePage.routeName);
    }
  }

  Future<void> _selectTime(List<DateTime>? initialDate, BuildContext context,
      int index, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.controller.selectedDates![index]),
    );

    if (picked != null) {
      setState(() {
        final selectedDate = DateTime(
          widget.controller.selectedDates![index].year,
          widget.controller.selectedDates![index].month,
          widget.controller.selectedDates![index].day,
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
          startTime![index] = DateTime.now().add(const Duration(minutes: 30));
          endTime![index] = startTime![index].add(const Duration(hours: 1));
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
          startTime![index] = selectedDate;

          // If endTime exists and is earlier than startTime, reset endTime
          if (endTime![index].isBefore(startTime![index])) {
            endTime![index] = startTime![index].add(const Duration(hours: 1));
          }
        } else {
          // If endTime is earlier than startTime, show an error and reset endTime
          if (selectedDate.isBefore(startTime![index])) {
            endTime![index] = startTime![index].add(const Duration(hours: 1));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.endTimeEarlyStartTime),
              ),
            );
          } else {
            // Update endTime at the given index
            endTime![index] = selectedDate;
          }
        }
      });
    }
  }

  void _load() {
    widget._createShowDetailBloc.add(LoadCreateShowDetailEvent());
  }
}
