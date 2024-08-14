import 'dart:convert';

import 'package:Noteshow/view/widgets/expanded_long_text_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../domain/home_page.dart/home_page_impl.dart';
import '../../create_show_detail/index.dart';
import '../index.dart';

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
    return ListView.builder(
        controller: controller,
        itemCount: lstEventCalendar.length,
        itemBuilder: (context, index) => Card(
              shadowColor: ColorName.bgAppBar,
              elevation: 0.5,
              color: Colors.transparent,
              margin: const EdgeInsets.all(AppMargin.m8),
              child: Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: (context) {
                          homePageImpl.delete(lstEventCalendar[index].id);
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppSize.s8)),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
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
                                ? "Paid"
                                : "UnPaid",
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
                                  '${DateFormat('dd/MM/yyyy').format(lstEventCalendar[index].startDate ?? DateTime.now())} -'
                                  // ignore: lines_longer_than_80_chars
                                  ' ${DateFormat('dd/MM/yyyy').format(lstEventCalendar[index].endDate ?? lstEventCalendar[index].startDate ?? DateTime.now())}',
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
