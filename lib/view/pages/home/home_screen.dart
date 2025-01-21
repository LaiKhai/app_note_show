import 'package:Noteshow/view/pages/home/pages/list_event_calender_widget.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../index.dart';
import 'bloc/statistic_bloc/index.dart';
import 'pages/search_bar_widget.dart';
import 'pages/statistical_widget.dart';

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
  final countShowController = AnimatedDigitController(0.00);
  final countAmountController = AnimatedDigitController(0.00);
  late final slideableController = SlidableController(this);
  final HomePageImpl homePageImpl = di.get();
  final controller = ScrollController();
  List<EventCalendar> lstEventCalendar = [];
  late final TabController _tabController;
  var currentTabIndex = 0;

  @override
  void initState() {
    listenController();
    super.initState();
    homePageImpl.load();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _onTabChanged(int index) async {
    switch (index) {
      case 0:
        homePageImpl.load(noteEnum: NotesEnum.ALL);
        break;
      case 1:
        homePageImpl.load(noteEnum: NotesEnum.PAID);
        break;
      case 2:
        homePageImpl.load(noteEnum: NotesEnum.UNPAID);
        break;
      case 3:
        homePageImpl.load(noteEnum: NotesEnum.OVERDUE);
        break;
      default:
    }
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
    return Column(
      children: [
        BlocBuilder<StatisticBlocBloc, StatisticBlocState>(
          bloc: homePageImpl.statisticBlocImpl,
          builder: (context, state) {
            if (state is CountTotalShowState) {
              countShowController.resetValue(int.parse(state.totalShow));
              countAmountController.resetValue(int.parse(
                  state.totalAmount.replaceAll(RegExp(r'[^\d]'), '')));
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticalWidget(
                  controller: countShowController,
                  title: AppLocalizations.of(context)!.totalShowPerMonth,
                ),
                StatisticalWidget(
                  controller: countAmountController,
                  title: AppLocalizations.of(context)!.totalMoneyPerMonth,
                ),
              ],
            );
          },
        ),
        const SearchBarWidget(),
        TabBar(
          controller: _tabController,
          // give the indicator a decoration (color and border radius)
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey, dividerColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          onTap: _onTabChanged,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.all,
            ),
            Tab(
              text: AppLocalizations.of(context)!.paid,
            ),
            Tab(
              text: AppLocalizations.of(context)!.unpaid,
            ),
            Tab(
              text: AppLocalizations.of(context)!.overdue,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        listNoteSection()
      ],
    );
  }

  Widget listNoteSection() {
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

          if (currentState is SearchTitleHomeState) {
            return ListEventCalendarWidget(
              controller: controller,
              lstEventCalendar: currentState.lstEventCalendar,
              homePageImpl: homePageImpl,
            );
          }
          if (currentState is FilterHomeState) {
            return ListEventCalendarWidget(
              controller: controller,
              lstEventCalendar: currentState.lstEventCalendar,
              homePageImpl: homePageImpl,
            );
          }
          if (currentState is InHomeState) {
            lstEventCalendar = currentState.lstEventCalendar;
          }

          return lstEventCalendar.isEmpty
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
                  lstEventCalendar: lstEventCalendar,
                  homePageImpl: homePageImpl,
                );
        });
  }
}
