abstract class HiveRepo {
  Future<void> create();
  Future<void> read();
  Future<void> update();
  Future<void> delete();
}
