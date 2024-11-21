import 'package:intl/intl.dart';

import '../../../../index.dart';
import 'button_submit_create_note.dart';

class ItemNote extends StatefulWidget {
  const ItemNote({
    super.key,
    required this.index,
    required this.formKeys,
    required this.titleFocusNode,
    required this.priceFocusNode,
    required this.decriptionFocusNode,
    required this.titleController,
    required this.priceController,
    required this.decriptionController,
    required this.listSelectTime,
    required this.calendars,
    required this.eventCalendarImpl,
    required this.createShowDetailController,
    required this.startTime,
    required this.endTime,
    required this.calendarController,
    required this.controller,
    required this.callBack,
    required this.selectTimeCallBack,
  });

  final int index;
  final List<GlobalKey<FormState>> formKeys;
  final List<FocusNode> titleFocusNode;
  final List<FocusNode> priceFocusNode;
  final List<FocusNode> decriptionFocusNode;
  final List<TextEditingController> titleController;
  final List<TextEditingController> priceController;
  final List<TextEditingController> decriptionController;
  final List<DateTime> listSelectTime;
  final List<Calendar>? calendars;
  final EventCalendarImpl eventCalendarImpl;
  final CreateShowDetailController createShowDetailController;
  final List<DateTime>? startTime;
  final List<DateTime>? endTime;
  final TextEditingController calendarController;
  final DateRangePickerController controller;
  final Function(List<DateTime>? listSelectTime) callBack;
  final Function(
    int index,
    DateTime? startTime,
    DateTime? endTime,
  ) selectTimeCallBack;
  @override
  State<ItemNote> createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  Calendar calendar = Calendar();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.listSelectTime[widget.index]),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (widget.titleFocusNode[widget.index].hasFocus ||
                widget.priceFocusNode[widget.index].hasFocus ||
                widget.decriptionFocusNode[widget.index].hasFocus) {
              widget.titleFocusNode[widget.index].unfocus();
              widget.priceFocusNode[widget.index].unfocus();
              widget.decriptionFocusNode[widget.index].unfocus();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSize.s16),
          child: Form(
            key: widget.formKeys[widget.index],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: title
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: widget.titleController[widget.index],
                    focusNode: widget.titleFocusNode[widget.index],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterSomeText;
                      }
                      return null;
                    },
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.titleEvent,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorName.black,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8))),
                  ),
                ),
                //TODO: prices
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: widget.priceController[widget.index],
                    focusNode: widget.priceFocusNode[widget.index],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterPrices;
                      }
                      return null;
                    },
                    autofillHints: const [AutofillHints.username],
                    inputFormatters: [
                      CurrencyInputFormatter(
                          thousandSeparator: ThousandSeparator.Period,
                          mantissaLength: 0,
                          trailingSymbol: 'đ')
                    ],

                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.pricesEvent,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorName.black,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8))),
                  ),
                ),

                // //TODO: Select calendar
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: DropdownMenu<Calendar>(
                    width: MediaQuery.of(context).size.width,
                    initialSelection: widget.calendars?.first,
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: widget.calendarController,
                    requestFocusOnTap: false,
                    label: Text(AppLocalizations.of(context)!.typeEvent),
                    onSelected: (Calendar? value) {
                      setState(() {
                        calendar = (value ?? widget.calendars?.first)!;
                      });
                    },
                    dropdownMenuEntries: widget.calendars!
                        .map<DropdownMenuEntry<Calendar>>((Calendar calendar) {
                      return DropdownMenuEntry<Calendar>(
                        value: calendar,
                        label: calendar.name ?? "",
                      );
                    }).toList(),
                  ),
                ),

                //TODO: date time
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s8),
                  child: Text(
                    AppLocalizations.of(context)!.startTimeEvent,
                    style: const TextStyle(
                        color: ColorName.black, fontWeight: FontWeight.w700),
                  ),
                ),

                //TODO: date time
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // The validator receives the text that the user has entered.

                          enabled: false,
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                              hintText: DateFormat(Constants.DAY_FORMAT).format(
                                  widget
                                      .controller.selectedDates![widget.index]),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: ColorName.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: AppSize.s8),
                        child: GestureDetector(
                            onTap: () async {
                              await widget.createShowDetailController
                                  .selectTime(context, widget.index, true,
                                      (startTime, endTime) {
                                widget.selectTimeCallBack(
                                    widget.index, startTime, endTime);
                              },
                                      selectedDates: widget.controller
                                          .selectedDates![widget.index],
                                      startTime:
                                          widget.startTime![widget.index],
                                      endTime: widget.endTime![widget.index]);
                            },
                            child: Container(
                              // margin: const EdgeInsets.all(15.0),
                              height: 55,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ColorName.black)),
                              child: Center(
                                child: Text(
                                  DateFormat(Constants.HOUR_FORMAT)
                                      .format(widget.startTime![widget.index]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
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
                  padding: const EdgeInsets.only(bottom: AppSize.s8),
                  child: Text(
                    AppLocalizations.of(context)!.endTimeEvent,
                    style: const TextStyle(
                        color: ColorName.black, fontWeight: FontWeight.w700),
                  ),
                ),

                //TODO: end date time
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // The validator receives the text that the user has entered.

                          enabled: false,
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                              hintText: DateFormat(Constants.DAY_FORMAT).format(
                                  widget
                                      .controller.selectedDates![widget.index]),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: ColorName.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: AppSize.s8),
                        child: GestureDetector(
                            onTap: () async {
                              await widget.createShowDetailController
                                  .selectTime(context, widget.index, false,
                                      (startTime, endTime) {
                                widget.selectTimeCallBack(
                                    widget.index, startTime, endTime);
                              },
                                      selectedDates: widget.controller
                                          .selectedDates![widget.index],
                                      startTime:
                                          widget.startTime![widget.index],
                                      endTime: widget.endTime![widget.index]);
                            },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ColorName.black)),
                              child: Center(
                                child: Text(
                                  DateFormat(Constants.HOUR_FORMAT)
                                      .format(widget.endTime![widget.index]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
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
                  padding: const EdgeInsets.only(bottom: AppSize.s8),
                  child: Text(
                    AppLocalizations.of(context)!.decriptionEvent,
                    style: const TextStyle(
                        color: ColorName.black, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.s16),
                  child: TextFormField(
                    controller: widget.decriptionController[widget.index],
                    focusNode: widget.decriptionFocusNode[widget.index],
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorName.black,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8))),
                  ),
                ),
                //TODO: button submit
                ButtonSubmitCreateNote(widget: widget, calendar: calendar),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
