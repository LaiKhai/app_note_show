import '../../../../index.dart';

class ButtonSubmitCreateNote extends StatelessWidget {
  const ButtonSubmitCreateNote({
    super.key,
    required this.widget,
    required this.calendar,
  });

  final ItemNote widget;
  final Calendar calendar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorName.bgAppBar,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s8))),
                onPressed: () async {
                  await widget.createShowDetailController.createEventCalendar(
                    context,
                    widget.eventCalendarImpl,
                    widget.formKeys,
                    widget.index,
                    calendar.name != null ? calendar : widget.calendars!.first,
                    (listSelectTime) {
                      widget.callBack(listSelectTime);
                    },
                    listSelectTime: widget.listSelectTime,
                    name: widget.titleController[widget.index].text,
                    price: widget.priceController[widget.index].text,
                    decription: widget.decriptionController[widget.index].text,
                    startDate: widget.startTime != null
                        ? widget.startTime![widget.index]
                        : DateTime.now(),
                    endDate: widget.endTime != null
                        ? widget.endTime![widget.index]
                        : DateTime.now(),
                    titleFocusNode: widget.titleFocusNode,
                    titleController: widget.titleController,
                    priceFocusNode: widget.priceFocusNode,
                    priceController: widget.priceController,
                    decriptionFocusNode: widget.decriptionFocusNode,
                    decriptionController: widget.decriptionController,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.createEvent,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: ColorName.colorGrey2),
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorName.bgTagUnPaid,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s8))),
                onPressed: () async {
                  widget.listSelectTime.removeAt(widget.index);
                  widget.callBack(widget.listSelectTime);
                  if (widget.listSelectTime.isEmpty) {
                    GoRouter.of(navigatorKey.currentContext!)
                        .pushReplacement(HomePage.routeName);
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
    );
  }
}
