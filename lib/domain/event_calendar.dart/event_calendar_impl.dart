import 'package:flutter_base_project/data/repository/hive_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class EventCalendarImpl implements HiveRepo {
  @override
  Future<void> create() async {}

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> read() {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<void> update() {
    // TODO: implement update
    throw UnimplementedError();
  }
}
