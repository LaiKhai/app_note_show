import 'package:Noteshow/data/repository/home_page_repo.dart';
import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:injectable/injectable.dart';

import '../../view/pages/home/index.dart';

@singleton
class HomePageImpl implements HomePageRepo {
  final HomeBloc homeBlocImpl;

  HomePageImpl({required this.homeBlocImpl});

  @override
  void delete(int dataId) {
    homeBlocImpl.add(DeleteDataEvent(dataId: dataId));
  }

  @override
  void load() {
    homeBlocImpl.add(LoadHomeEvent());
  }

  @override
  void filterDate(DateTime startDate, DateTime endDate) {
    homeBlocImpl.add(FilterDateTimeDataEvent(startDate, endDate));
  }

  @override
  void updatePaidStatus(EventCalendar event) {
    homeBlocImpl.add(UpdatePaidDataEvent(event: event));
  }
}
