// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../index.dart';

class ListEventCalendarWidget extends StatefulWidget {
  final List<EventCalendar> lstEventCalendar;
  final ScrollController controller;
  final HomePageImpl homePageImpl;

  const ListEventCalendarWidget(
      {super.key,
      required this.lstEventCalendar,
      required this.controller,
      required this.homePageImpl});

  @override
  State<ListEventCalendarWidget> createState() =>
      _ListEventCalendarWidgetState();
}

class _ListEventCalendarWidgetState extends State<ListEventCalendarWidget> {
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;
  bool isSelectedAll = false;
  @override
  Widget build(BuildContext context) {
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    return Expanded(
      child: Column(
        children: [
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.all(AppMargin.m8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _selectAll(),
                        child: Icon(
                          isSelectedAll
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: ColorName.colorGrey2,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.selectedItems(
                          selectedFlag.entries
                              .where((element) => element.value == true)
                              .length)),
                    ],
                  ),
                  PopupMenuButton<void Function()>(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: () {
                            final selectedItem = selectedFlag.entries
                                .where((element) => element.value == true)
                                .toList();
                            if (selectedItem.isNotEmpty) {
                              for (var element in selectedItem) {
                                widget.homePageImpl.delete(
                                    widget.lstEventCalendar[element.key].id);
                              }
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.deleted),
                        ),
                        PopupMenuItem(
                          value: () {
                            final selectedItem = selectedFlag.entries
                                .where((element) => element.value == true)
                                .toList();
                            for (var element in selectedItem) {
                              widget.lstEventCalendar[element.key].isPaid =
                                  !widget.lstEventCalendar[element.key].isPaid!;
                              final json = jsonEncode(
                                  widget.lstEventCalendar[element.key].toMap());
                              final event =
                                  EventCalendar.fromMap(jsonDecode(json));

                              widget.homePageImpl.updatePaidStatus(event);
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.payOrUnPay),
                        ),
                      ];
                    },
                    onSelected: (fn) => fn(),
                  )
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
                controller: widget.controller,
                itemCount: widget.lstEventCalendar.length,
                itemBuilder: (context, index) =>
                    noteItems(index, deviceCalendarPlugin, context)),
          ),
        ],
      ),
    );
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
      isSelectedAll = !selectedFlag.containsValue(false);
    });
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      // If there will be any true in the selectionFlag then
      // selection Mode will be true
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    return GestureDetector(
      onTap: () => onTap(isSelected, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppMargin.m4),
        child: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: ColorName.colorGrey2,
        ),
      ),
    );
  }

  Widget noteItems(int index, DeviceCalendarPlugin deviceCalendarPlugin,
      BuildContext context) {
    selectedFlag[index] = selectedFlag[index] ?? false;
    bool isSelected = selectedFlag[index] ?? false;
    return Row(
      children: [
        if (isSelectionMode) _buildSelectIcon(isSelected, index),
        Expanded(
          child: GestureDetector(
            onLongPress: () => onLongPress(isSelected, index),
            onTap: () => onTap(isSelected, index),
            child: Card(
              elevation: 0.0,
              color: ColorName.colorGrey3,
              child: Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                    bodyText: AppLocalizations.of(context)
                                            ?.contentDelete ??
                                        "",
                                    specialText:
                                        widget.lstEventCalendar[index].name!,
                                    acceptText:
                                        AppLocalizations.of(context)?.accept ??
                                            "",
                                    denyText:
                                        AppLocalizations.of(context)?.cancel ??
                                            "",
                                    onAccept: () async {
                                      await deviceCalendarPlugin.deleteEvent(
                                          widget.lstEventCalendar[index]
                                              .calendarId!,
                                          widget.lstEventCalendar[index]
                                                  .eventId ??
                                              "");
                                      widget.homePageImpl.delete(
                                          widget.lstEventCalendar[index].id);
                                      GoRouter.of(context).pop();
                                    },
                                    onDeny: () {
                                      GoRouter.of(context).pop();
                                    },
                                  ));
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppSize.s8)),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: AppLocalizations.of(context)?.labelDelete ?? "",
                      ),
                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppSize.s8)),
                        onPressed: (context) {
                          widget.lstEventCalendar[index].isPaid =
                              !widget.lstEventCalendar[index].isPaid!;
                          final json = jsonEncode(
                              widget.lstEventCalendar[index].toMap());
                          final event = EventCalendar.fromMap(jsonDecode(json));

                          widget.homePageImpl.updatePaidStatus(event);
                        },
                        backgroundColor:
                            widget.lstEventCalendar[index].isPaid ?? false
                                ? ColorName.bgTagUnPaid
                                : ColorName.bgTagPaid,
                        foregroundColor: Colors.white,
                        icon: Icons.attach_money_rounded,
                        label: widget.lstEventCalendar[index].isPaid ?? false
                            ? AppLocalizations.of(context)!.unpaid
                            : AppLocalizations.of(context)!.paid,
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,

                      /// Prevents the mouse cursor to highlight the tile when hovering on web.
                      hoverColor: Colors.transparent,

                      /// Hides the highlight color when the tile is pressed.
                      highlightColor: Colors.transparent,

                      /// Makes the top and bottom dividers invisible when expanded.
                      dividerColor: Colors.transparent,

                      /// Make background transparent.
                      expansionTileTheme: const ExpansionTileThemeData(
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                      ),
                    ),
                    child: buildContentNote(index, context),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContentNote(int index, BuildContext context) {
    return ListTile(
      dense: false,
      trailing: Container(
        margin: const EdgeInsets.all(AppSize.s8),
        decoration: BoxDecoration(
            color: widget.lstEventCalendar[index].isPaid ?? false
                ? ColorName.bgTagPaid
                : ColorName.bgTagUnPaid,
            borderRadius: BorderRadius.circular(AppSize.s8)),
        child: Padding(
          padding: const EdgeInsets.all(AppSize.s4),
          child: Text(
            widget.lstEventCalendar[index].isPaid ?? false
                ? AppLocalizations.of(context)?.paid ?? ""
                : AppLocalizations.of(context)?.unpaid ?? "",
            style: const TextStyle(color: ColorName.white),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppMargin.m8),
        child: Text(
          widget.lstEventCalendar[index].name ?? "Unkown",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: ColorName.black,
              fontSize: AppSize.s16,
              fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppMargin.m8),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: AppSize.s14,
                  weight: 400,
                  color: ColorName.colorGrey2,
                ),
                const SizedBox(
                  width: AppSize.s4,
                ),
                Expanded(
                  child: Text(
                    '${DateFormat(Constants.DAY_FORMAT).format(widget.lstEventCalendar[index].startDate ?? DateTime.now())} -'
                    // ignore: lines_longer_than_80_chars
                    ' ${DateFormat(Constants.HOUR_FORMAT).format(widget.lstEventCalendar[index].startDate ?? DateTime.now())} to ${DateFormat(Constants.HOUR_FORMAT).format(widget.lstEventCalendar[index].endDate ?? DateTime.now())}',
                    style: const TextStyle(
                      fontSize: FontSize.s12,
                      color: ColorName.colorGrey2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppMargin.m8),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  size: AppSize.s14,
                  weight: 400,
                  color: ColorName.colorGrey2,
                ),
                Text(
                  widget.lstEventCalendar[index].price ?? "",
                  style: const TextStyle(
                    fontSize: FontSize.s12,
                    color: ColorName.colorGrey2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: AppMargin.m8),
              child: ExpandedLongTextWidget(
                  text: widget.lstEventCalendar[index].decription ?? "")),
        ],
      ),
    );
  }
}
