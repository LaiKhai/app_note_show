import 'package:Noteshow/core/gen/assets.gen.dart';
import 'package:Noteshow/domain/home_page.dart/home_page_impl.dart';
import 'package:Noteshow/domain/services/isar_services.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:Noteshow/view/pages/home/pages/list_event_calender_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../calendar/calendar_page.dart';
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
            return ListEventCalendarWidget(
              controller: controller,
              lstEventCalendar: currentState.lstEventCalendar,
              homePageImpl: homePageImpl,
            );
          }
          if (currentState is InHomeState) {
            return currentState.lstEventCalendar.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Assets.images.emptyPage.image(),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              "No notes have been created yet! Create your own note!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: ColorName.colorGrey2),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                GoRouter.of(navigatorKey.currentContext!)
                                    .go(CalendarPage.routeName);
                              } on PlatformException catch (e) {
                                print(e);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.bgAppBar,
                            ),
                            child: const Text(
                              "Go to create note",
                              style: TextStyle(color: ColorName.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : ListEventCalendarWidget(
                    controller: controller,
                    lstEventCalendar: currentState.lstEventCalendar,
                    homePageImpl: homePageImpl,
                  );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
