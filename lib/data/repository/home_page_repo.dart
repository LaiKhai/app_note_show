import 'package:Noteshow/main.dart';
import 'package:injectable/injectable.dart';

import '../../view/pages/create_show_detail/index.dart';

abstract class HomePageRepo {
  @factoryMethod
  void load({NotesEnum? noteEnum});
  @factoryMethod
  void delete(int dataId);
  @factoryMethod
  void filterDate(DateTime startDate, DateTime endDate);
  @factoryMethod
  void searchTitle(String title);
  @factoryMethod
  void updatePaidStatus(EventCalendar event);
}
