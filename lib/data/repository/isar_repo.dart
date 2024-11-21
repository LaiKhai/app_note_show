abstract class IsarRepo {
  Future<void> open();
  Future<void> saveData(dynamic object);
  Stream<List<dynamic>> listenData();
  Future<List<dynamic>> getAllData();
  Future<List<dynamic>> getPaidData();
  Future<List<dynamic>> getUnPaidData();
  Future<List<dynamic>> getOverdueData();
  Future<void> updateData(dynamic object);
  Future<void> deleteData(int id);
  Future<dynamic> filterDateTime(DateTime startDate, DateTime endDate);
  Future<dynamic> searchTitleEvent(String title);
  Future<List<dynamic>> countTotal();
}
