import 'package:Noteshow/view/pages/home/pages/list_event_calender_widget.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../index.dart';
import 'bloc/statistic_bloc/index.dart';
import 'pages/search_bar_widget.dart';

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
    return Column(
      children: [
        const SearchBarWidget(),
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
                  title: 'Total show per month',
                ),
                StatisticalWidget(
                  controller: countAmountController,
                  title: 'Total money per month',
                ),
              ],
            );
          },
        ),
        BlocBuilder<HomeBloc, HomeState>(
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
            }),
      ],
    );
  }
}

class StatisticalWidget extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final AnimatedDigitController controller;
  const StatisticalWidget({
    super.key,
    this.title,
    required this.controller,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 80,
            decoration: BoxDecoration(
                color: ColorName.colorGrey3,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDigitWidget(
                    autoSize: false,
                    controller: controller,
                    textStyle: DefaultTextStyle.of(context).style.copyWith(
                        color: ColorName.black,
                        fontSize: fontSize ?? FontSize.s14,
                        fontWeight: FontWeight.bold),
                    enableSeparator: true,
                  ),
                  Text(
                    title ?? 'total shows per month',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: ColorName.colorGrey2, fontSize: 10),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
