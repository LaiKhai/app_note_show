// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:Noteshow/view/widgets/expanded_long_text_widget.dart';

import '../../../../domain/home_page.dart/home_page_impl.dart';
import '../../../../index.dart';
import '../../../widgets/dialog_widget/confirm_dialog_widget.dart';
import '../../create_show_detail/index.dart';

class ListEventCalendarWidget extends StatelessWidget {
  final List<EventCalendar> lstEventCalendar;
  final ScrollController controller;
  final HomePageImpl homePageImpl;
  const ListEventCalendarWidget(
      {super.key,
      required this.lstEventCalendar,
      required this.controller,
      required this.homePageImpl});

  @override
  Widget build(BuildContext context) {
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    return ListView.builder(
        controller: controller,
        itemCount: lstEventCalendar.length,
        itemBuilder: (context, index) => Card(
              shadowColor: ColorName.bgAppBar,
              elevation: 0.5,
              color: Colors.transparent,
              margin: const EdgeInsets.all(AppMargin.m8),
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
                                    specialText: lstEventCalendar[index].name!,
                                    acceptText:
                                        AppLocalizations.of(context)?.accept ??
                                            "",
                                    denyText:
                                        AppLocalizations.of(context)?.cancel ??
                                            "",
                                    onAccept: () async {
                                      await deviceCalendarPlugin.deleteEvent(
                                          lstEventCalendar[index].calendarId!,
                                          lstEventCalendar[index].eventId ??
                                              "");
                                      homePageImpl
                                          .delete(lstEventCalendar[index].id);
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
                          lstEventCalendar[index].isPaid =
                              !lstEventCalendar[index].isPaid!;
                          final json =
                              jsonEncode(lstEventCalendar[index].toMap());
                          final event = EventCalendar.fromMap(jsonDecode(json));

                          homePageImpl.updatePaidStatus(event);
                        },
                        backgroundColor: lstEventCalendar[index].isPaid ?? false
                            ? ColorName.bgTagUnPaid
                            : ColorName.bgTagPaid,
                        foregroundColor: Colors.white,
                        icon: Icons.attach_money_rounded,
                        label: lstEventCalendar[index].isPaid ?? false
                            ? 'UnPaid'
                            : 'Paid',
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
                    child: ExpansionTile(
                      dense: false,
                      trailing: Container(
                        margin: const EdgeInsets.all(AppSize.s8),
                        decoration: BoxDecoration(
                            color: lstEventCalendar[index].isPaid ?? false
                                ? ColorName.bgTagPaid
                                : ColorName.bgTagUnPaid,
                            borderRadius: BorderRadius.circular(AppSize.s8)),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.s4),
                          child: Text(
                            lstEventCalendar[index].isPaid ?? false
                                ? AppLocalizations.of(context)?.paid ?? ""
                                : AppLocalizations.of(context)?.unpaid ?? "",
                            style: const TextStyle(color: ColorName.white),
                          ),
                        ),
                      ),
                      title: Text(
                        lstEventCalendar[index].name ?? "Unkown",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ColorName.white,
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(AppMargin.m16),
                            child: ExpandedLongTextWidget(
                                text:
                                    lstEventCalendar[index].decription ?? "")),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0, AppMargin.m8, 0, AppMargin.m8),
                          child: Container(
                            height: 0.2,
                            color: ColorName.colorGrey2,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(AppMargin.m8, 0, 0, 0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.attach_money_rounded,
                                size: AppSize.s20,
                                weight: 400,
                                color: ColorName.white,
                              ),
                              Text(
                                lstEventCalendar[index].price ?? "",
                                style: const TextStyle(
                                    color: ColorName.white,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppMargin.m8, AppMargin.m16, 0, AppMargin.m16),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: AppSize.s20,
                                  weight: 400,
                                  color: ColorName.white),
                              const SizedBox(
                                width: AppSize.s4,
                              ),
                              Text(
                                  '${DateFormat(Constants.DAY_FORMAT).format(lstEventCalendar[index].startDate ?? DateTime.now())} -'
                                  // ignore: lines_longer_than_80_chars
                                  ' ${DateFormat(Constants.HOUR_FORMAT).format(lstEventCalendar[index].startDate ?? DateTime.now())} to ${DateFormat(Constants.HOUR_FORMAT).format(lstEventCalendar[index].endDate ?? DateTime.now())}',
                                  style: const TextStyle(
                                      color: ColorName.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ));
  }
}
