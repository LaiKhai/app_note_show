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
  final CreateShowDetailController createShowDetailController = di.get();
  late final List<GlobalKey<FormState>> formKeys;
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
    createShowDetailController.load(widget._createShowDetailBloc);
  }

  void initialVariable() {
    if (widget.controller.selectedDates != null) {
      listSelectTime = widget.controller.selectedDates ?? [];
      listSelectTime?.sort();
      formKeys = List.generate(
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
                    onPressed: () => createShowDetailController
                        .load(widget._createShowDetailBloc),
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
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DateTimeLabel(
                                listSelectTime: listSelectTime![index]),
                            ItemNote(
                              index: index,
                              formKeys: formKeys,
                              titleFocusNode: titleFocusNode,
                              priceFocusNode: priceFocusNode,
                              decriptionFocusNode: decriptionFocusNode,
                              titleController: titleController,
                              priceController: priceController,
                              decriptionController: decriptionController,
                              listSelectTime: listSelectTime!,
                              calendars: currentState.calendars!,
                              eventCalendarImpl: eventCalendarImpl,
                              createShowDetailController:
                                  createShowDetailController,
                              calendarController: calendarController,
                              controller: widget.controller,
                              startTime: startTime,
                              endTime: endTime,
                              callBack: (listSelectTime) {
                                listSelectTime = listSelectTime ?? [];
                                setState(() {});
                              },
                              selectTimeCallBack:
                                  (index, startTimeSelected, endTimeSelected) {
                                startTime?[index] = startTimeSelected!;
                                endTime?[index] = endTimeSelected!;
                                setState(() {});
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 70,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.add,
                                      color: ColorName.colorGrey2,
                                    )),
                              ),
                            )
                          ],
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
}
