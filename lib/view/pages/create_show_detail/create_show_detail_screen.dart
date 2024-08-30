import 'package:Noteshow/view/res/responsive/reponsive_extension.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../widgets/empty_page.dart';
import '../home/home_page.dart';
import 'index.dart';

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
  CreateShowDetailScreenState();

  final EventCalendarImpl eventCalendarImpl = di.get();

  late final List<GlobalKey<FormState>> _formKeys;
  late final List<FocusNode> titleFocusNode;
  late final List<FocusNode> priceFocusNode;
  late final List<FocusNode> decriptionFocusNode;
  late final List<TextEditingController> titleController;
  late final List<TextEditingController> priceController;
  late final List<TextEditingController> decriptionController;
  List<DateTime>? listSelectTime = [];
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
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
    }

    _load();
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
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InCreateShowDetailState) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return (listSelectTime == null || listSelectTime!.isEmpty)
                    ? Center(
                        child: EmptyPage(
                          bodyText:
                              "The page is currently empty! You can come back.",
                          onPressedText: "Back to Calendar",
                          onPressed: () {
                            try {
                              GoRouter.of(navigatorKey.currentContext!).pop();
                            } on PlatformException catch (e) {
                              print(e);
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
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        autofillHints: const [
                                          AutofillHints.username
                                        ],
                                        decoration: InputDecoration(
                                            labelText: 'Title',
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
                                            return 'Please enter some text';
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
                                            labelText: 'Prices',
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: ColorName.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.s8))),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: AppSize.s8),
                                      child: Text(
                                        "Start Time",
                                        style: TextStyle(
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
                                                          'dd/MM/yyyy')
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
                                                  await _selectTime(
                                                      context, index);
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
                                                      DateFormat.jms().format(
                                                          widget.controller
                                                                  .selectedDates![
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

                                    //TODO: decription
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorName.bgAppBar,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSize.s8))),
                                            onPressed: () async {
                                              await _createEventCalendar(index);
                                            },
                                            child: const Text(
                                              'Create Event',
                                              style: TextStyle(
                                                  color: ColorName.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppSize.s10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorName.bgTagUnPaid,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSize.s8))),
                                            onPressed: () async {
                                              setState(() {
                                                listSelectTime?.removeAt(index);
                                              });
                                              if (listSelectTime!.isEmpty) {
                                                GoRouter.of(navigatorKey
                                                        .currentContext!)
                                                    .pushReplacement(
                                                        HomePage.routeName);
                                              }
                                            },
                                            child: const Text(
                                              'Delete Event',
                                              style: TextStyle(
                                                  color: ColorName.white),
                                            ),
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

  Future<void> _createEventCalendar(int index) async {
    if (_formKeys[index].currentState!.validate()) {
      // Validate returns true if the form is valid, or false otherwise.\
      final eventCalendar = EventCalendar(
          name: titleController[index].text,
          price: priceController[index].text,
          decription: decriptionController[index].text,
          startDate: widget.controller.selectedDates != null
              ? widget.controller.selectedDates![index]
              : DateTime.now(),
          endDate: widget.controller.selectedDates != null
              ? widget.controller.selectedDates![index]
              : DateTime.now(),
          isPaid: false);
      await eventCalendarImpl.createEventCalendar(eventCalendar);
      await eventCalendarImpl.createEventToCalendarDevice(eventCalendar);

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Send data successfully')),
      );
      _removeEvent(index);
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

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.controller.selectedDates![index]),
    );
    if (picked != null) {
      setState(() {
        widget.controller.selectedDates![index] = DateTime(
          widget.controller.selectedDates![index].year,
          widget.controller.selectedDates![index].month,
          widget.controller.selectedDates![index].day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _load() {
    widget._createShowDetailBloc.add(LoadCreateShowDetailEvent());
  }
}
