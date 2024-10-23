import 'package:Noteshow/view/pages/home/pages/list_event_calender_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    super.key,
    required this.callback,
  });

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
                    child: Text(AppLocalizations.of(context)!.reload),
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
                ? Center(
                    child: EmptyPage(
                      bodyText: AppLocalizations.of(context)?.emptyPage ?? "",
                      onPressedText:
                          AppLocalizations.of(context)?.createNote ?? "",
                      onPressed: () {
                        try {
                          GoRouter.of(navigatorKey.currentContext!)
                              .go(CalendarPage.routeName);
                        } on PlatformException catch (e) {
                          EasyLoading.showError(e.toString());
                        }
                      },
                    ),
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
