import 'package:Noteshow/data/repository/home_page_repo.dart';
import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:Noteshow/view/pages/home/bloc/statistic_bloc/index.dart';
import 'package:injectable/injectable.dart';

import '../../view/pages/home/index.dart';

@LazySingleton()
class HomePageImpl implements HomePageRepo {
  final HomeBloc homeBlocImpl;
  final StatisticBlocBloc statisticBlocImpl;

  HomePageImpl({required this.statisticBlocImpl, required this.homeBlocImpl});

  @override
  void delete(int dataId) {
    homeBlocImpl.add(DeleteDataEvent(dataId: dataId));
  }

  @override
  void load() {
    homeBlocImpl.add(LoadHomeEvent());
    statisticBlocImpl.add(CountTotalShowEvent());
  }

  @override
  void filterDate(DateTime startDate, DateTime endDate) {
    homeBlocImpl.add(FilterDateTimeDataEvent(startDate, endDate));
  }

  @override
  void updatePaidStatus(EventCalendar event) {
    homeBlocImpl.add(UpdatePaidDataEvent(event: event));
    Future.delayed(const Duration(seconds: 1),
        () => statisticBlocImpl.add(CountTotalShowEvent()));
  }

  @override
  void searchTitle(String title) {
    homeBlocImpl.add(SearchDataEvent(title));
  }
}
