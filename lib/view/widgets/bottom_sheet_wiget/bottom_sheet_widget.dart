import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../index.dart';

@singleton
class BottomSheetModal {
  showBottomSheet(BuildContext context, Widget widget,
      {EdgeInsetsDirectional? padding}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: padding ?? const EdgeInsetsDirectional.all(AppSize.s8),
          child: widget,
        );
      },
    );
  }

  Future<List<EventCalendar>> fetchData() async {
    final IsarServices isarServices = di.get();
    return await isarServices.getAllData();
  }

  Widget buildBottomSheet(void Function(void Function() fn) setState) {
    DateTime? startDateTimeValue;
    DateTime? endDateTimeValue;
    final HomePageImpl homePageImpl = di.get();

    return FutureBuilder<List<EventCalendar>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DateTime> mergedList = groupDateTime(snapshot.data!);
          if (mergedList.isNotEmpty) {
            startDateTimeValue = startDateTimeValue ?? mergedList.first;
            endDateTimeValue = endDateTimeValue ?? mergedList.first;
          }

          return mergedList.isEmpty
              ? SizedBox(
                  height: AppSize.s160,
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "No notes have been created yet! Create your own note!")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                GoRouter.of(context).pop();
                              } on PlatformException catch (e) {
                                debugPrint("$e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.bgAppBar,
                            ),
                            child: const Text(
                              "Back",
                              style: TextStyle(color: ColorName.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: AppSize.s160,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorName.colorGrey2,
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownMenu<DateTime>(
                                textStyle: const TextStyle(
                                    color: ColorName.white, fontSize: 13),
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(8),
                                  suffixIconColor: ColorName.white,
                                ),
                                width: AppSize.s140,
                                initialSelection: startDateTimeValue,
                                onSelected: (DateTime? value) {
                                  // This is called when the user selects an item.

                                  setState(
                                    () {
                                      startDateTimeValue =
                                          value ?? DateTime.now();
                                    },
                                  );
                                },
                                dropdownMenuEntries: mergedList
                                    .map<DropdownMenuEntry<DateTime>>(
                                        (DateTime value) {
                                  return DropdownMenuEntry<DateTime>(
                                      value: value,
                                      label: DateFormat(Constants.DAY_FORMAT)
                                          .format(value));
                                }).toList(),
                              ),
                            ),
                            const Text(
                              "To",
                              style: TextStyle(
                                  color: ColorName.colorGrey2,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorName.colorGrey2,
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownMenu<DateTime>(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(8),
                                        suffixIconColor: ColorName.white),
                                textStyle: const TextStyle(
                                    color: ColorName.white, fontSize: 13),
                                width: AppSize.s140,
                                initialSelection: endDateTimeValue,
                                onSelected: (DateTime? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    endDateTimeValue = value ?? DateTime.now();
                                  });
                                },
                                dropdownMenuEntries: mergedList
                                    .map<DropdownMenuEntry<DateTime>>(
                                        (DateTime value) {
                                  return DropdownMenuEntry<DateTime>(
                                      labelWidget: Text(
                                        DateFormat(Constants.DAY_FORMAT)
                                            .format(value),
                                        style: const TextStyle(
                                            color: ColorName.colorGrey2),
                                      ),
                                      value: value,
                                      label: DateFormat(Constants.DAY_FORMAT)
                                          .format(value));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                if (startDateTimeValue!
                                        .compareTo(endDateTimeValue!) <=
                                    0) {
                                  homePageImpl.filterDate(
                                      startDateTimeValue!, endDateTimeValue!);
                                } else {
                                  ScaffoldMessenger.of(
                                          navigatorKey.currentContext!)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Start time cannot be greater than end time')),
                                  );
                                }
                              } on PlatformException catch (e) {
                                debugPrint("$e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.colorGrey2,
                            ),
                            child: const Text(
                              "Search",
                              style: TextStyle(color: ColorName.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }
      },
    );
  }
}
