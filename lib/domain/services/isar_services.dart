import 'package:Noteshow/domain/event_calendar.dart/event_calendar_model.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/repository/isar_repo.dart';
import '../../view/pages/create_show_detail/index.dart';

@singleton
class IsarServices implements IsarRepo {
  late Future<Isar> db;

  //we define db that we want to use as late
  IsarServices() {
    db = open();
    //open DB for use.
  }

  @override
  Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [EventCalendarSchema],
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> deleteData(int id) async {
    final isar = await db;
    //Perform a write transaction to delete the user with the specified ID.
    isar.writeTxnSync(() => isar.eventCalendars.deleteSync(id));
  }

  @override
  Future filterDateTime(startDate, endDate) async {
    final isar = await db;

    final preliminaryResults = isar.eventCalendars
        .filter()
        .startDateBetween(startDate, endDate)
        .or()
        .endDateBetween(startDate, endDate)
        .findAllSync();

    return preliminaryResults;
  }

  @override
  Future<List<EventCalendar>> getAllData() async {
    final isar = await db;
    //Find all users in the user collection and return the list.
    final data = await isar.eventCalendars.where().findAll();
    return data;
  }

  @override
  Stream<List<EventCalendar>> listenData() async* {
    final isar = await db;
    //Watch the user collection for changes and yield the updated user list.
    yield* isar.eventCalendars.where().watch(fireImmediately: true);
  }

  @override
  Future<void> saveData(object) async {
    final isar = await db;
    //Perform a synchronous write transaction to add the user to the database.
    isar.writeTxn(() => isar.eventCalendars.put(object));
  }

  @override
  Future<void> updateData(object) async {
    final isar = await db;
    await isar.writeTxnSync(() async {
      //Perform a write transaction to update the user in the database.
      isar.eventCalendars.putSync(object);
    });
  }

  @override
  Future searchTitleEvent(String title) async {
    final isar = await db;

    final searchResult =
        isar.eventCalendars.filter().nameContains(title).findAllSync();
    return searchResult;
  }

  @override
  Future<List<EventCalendar>> countTotal() async {
    final isar = await db;

    final countTotalAmount =
        isar.eventCalendars.filter().isPaidEqualTo(true).findAllSync();

    return countTotalAmount;
  }

  @override
  Future<List<EventCalendar>> getOverdueData() async {
    final isar = await db;

    final listOverDueData = isar.eventCalendars
        .filter()
        .startDateLessThan(DateTime.now())
        .findAllSync();

    return listOverDueData;
  }

  @override
  Future<List<EventCalendar>> getPaidData() async {
    final isar = await db;

    final listPaidData =
        isar.eventCalendars.filter().isPaidEqualTo(true).findAllSync();

    return listPaidData;
  }

  @override
  Future<List<EventCalendar>> getUnPaidData() async {
    final isar = await db;

    final listUnPaidData =
        isar.eventCalendars.filter().isPaidEqualTo(false).findAllSync();

    return listUnPaidData;
  }
}
