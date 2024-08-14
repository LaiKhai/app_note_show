import 'package:Noteshow/domain/home_page.dart/home_page_impl.dart';
import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:Noteshow/view/pages/home/pages/list_event_calender_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    super.key,
    required this.callback,
  }) : _homeBloc = homeBloc;

  final HomeBloc _homeBloc;
  final Function(bool isVisible) callback;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeScreenState();

  late final slideableController = SlidableController(this);
  final HomePageImpl homePageImpl = di.get();
  final IsarServices isarServices = di.get();
  DateTime? startDateTimeValue;
  DateTime? endDateTimeValue;
  final controller = ScrollController();

  @override
  void initState() {
    listenController();
    super.initState();
    homePageImpl.load();
  }

  void listenController() {
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          widget.callback(false);
        } else {
          widget.callback(true);
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: homePageImpl.homeBlocImpl,
        builder: (
          BuildContext context,
          HomeState currentState,
        ) {
          if (currentState is UnHomeState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorHomeState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: homePageImpl.load,
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is FilterHomeState) {
            return buildCalendarEventList(
                currentState.lstEventCalendar, currentState.mergedList);
          }
          if (currentState is InHomeState) {
            return buildCalendarEventList(
                currentState.lstEventCalendar, currentState.mergedList);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  RenderObjectWidget buildCalendarEventList(
      List<EventCalendar> lstEventCalendar, List<DateTime> mergedList) {
    return lstEventCalendar.isEmpty
        ? const Center(
            child: Text(
              "Add your note...",
              style: TextStyle(color: ColorName.black),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 199, 167, 119),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownMenu<DateTime>(
                          inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                              suffixIconColor: ColorName.white,
                              hintStyle: TextStyle(color: ColorName.white),
                              labelStyle: TextStyle(color: ColorName.white)),
                          width: AppSize.s160,
                          initialSelection:
                              startDateTimeValue ?? mergedList.first,
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
                            color: const Color.fromARGB(255, 199, 167, 119),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownMenu<DateTime>(
                          inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          width: AppSize.s160,
                          initialSelection:
                              endDateTimeValue ?? mergedList.first,
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
                                value: value,
                                label: DateFormat('dd/MM/yyyy').format(value));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      homePageImpl.filterDate(
                          startDateTimeValue ?? mergedList.first,
                          endDateTimeValue ?? mergedList.first);
                    },
                    child: const Text("Search"),
                  ),
                ),
                Expanded(
                  child: ListEventCalendarWidget(
                    controller: controller,
                    lstEventCalendar: lstEventCalendar,
                    homePageImpl: homePageImpl,
                  ),
                ),
              ],
            ),
          );
  }
}
