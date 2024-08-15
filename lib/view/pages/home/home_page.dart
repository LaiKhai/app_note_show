import 'package:Noteshow/core/network/network_controller.dart';
import 'package:Noteshow/view/pages/calendar/calendar_page.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:Noteshow/view/pages/profile/profile/index.dart';
import 'package:Noteshow/view/widgets/bottom_sheet_wiget/bottom_sheet_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/home_page.dart/home_page_impl.dart';
import '../../../domain/services/isar_services.dart';
import '../../../main.dart';
import 'index.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(const UnHomeState());
  final IsarServices isarServices = di.get();
  final HomePageImpl homePageImpl = di.get();
  final NetworkController networkController = di.get();
  final BottomSheetModal bottomSheetModal = di.get();
  DateTime? startDateTimeValue;
  DateTime? endDateTimeValue;
  @override
  void initState() {
    networkController.onInit();
    super.initState();
  }

  bool hidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: HomeScreen(
        homeBloc: _homeBloc,
        callback: (bool isVisible) {
          setState(() {
            hidden = isVisible;
          });
        },
      )),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Visibility(
          visible: hidden,
          child: ExpandableFab(distance: 100, children: [
            FloatingActionButton.small(
                heroTag: "person",
                // backgroundColor: ColorName.bgAppBar,
                onPressed: () {
                  GoRouter.of(navigatorKey.currentContext!)
                      .pushReplacement(ProfilePage.routeName);
                },
                child: const Icon(Icons.person, color: ColorName.white)),
            FloatingActionButton.small(
                heroTag: "search",
                // backgroundColor: ColorName.bgAppBar,
                onPressed: () async {
                  // final lstEventCalendar = await isarServices.getAllData();
                  // List<DateTime> mergedList = groupDateTime(lstEventCalendar);
                  bottomSheetModal.showBottomSheet(context, buildBottomSheet(),
                      padding: const EdgeInsetsDirectional.all(AppSize.s16));
                },
                child: const Icon(Icons.search, color: ColorName.white)),
            FloatingActionButton.small(
                heroTag: "post",
                // backgroundColor: ColorName.bgAppBar,
                onPressed: () {
                  GoRouter.of(navigatorKey.currentContext!)
                      .pushReplacement(CalendarPage.routeName);
                },
                child:
                    const Icon(Icons.post_add_rounded, color: ColorName.white)),
          ])),
    );
  }

  Future<List<EventCalendar>> fetchData() async {
    return await isarServices.getAllData();
  }

  Widget buildBottomSheet() {
    return FutureBuilder<List<EventCalendar>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DateTime> mergedList = groupDateTime(snapshot.data!);
          startDateTimeValue = startDateTimeValue ?? mergedList.first;
          endDateTimeValue = endDateTimeValue ?? mergedList.first;
          return SizedBox(
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
                            color: ColorName.bgAppBar,
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownMenu<DateTime>(
                          textStyle: const TextStyle(
                              color: ColorName.white, fontSize: 13),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                            suffixIconColor: ColorName.white,
                          ),
                          width: AppSize.s140,
                          initialSelection: startDateTimeValue,
                          onSelected: (DateTime? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              startDateTimeValue = value ?? DateTime.now();
                            });
                          },
                          dropdownMenuEntries: mergedList
                              .map<DropdownMenuEntry<DateTime>>(
                                  (DateTime value) {
                            return DropdownMenuEntry<DateTime>(
                                value: value,
                                label: DateFormat('dd/MM/yyyy').format(value));
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
                            color: ColorName.bgAppBar,
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownMenu<DateTime>(
                          inputDecorationTheme: const InputDecorationTheme(
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
                                  DateFormat('dd/MM/yyyy').format(value),
                                  style: const TextStyle(
                                      color: ColorName.colorGrey2),
                                ),
                                value: value,
                                label: DateFormat('dd/MM/yyyy').format(value));
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
                            ScaffoldMessenger.of(navigatorKey.currentContext!)
                                .showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Start time cannot be greater than end time')),
                            );
                          }
                        } on PlatformException catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorName.bgAppBar,
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
