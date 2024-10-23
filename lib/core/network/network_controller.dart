import 'package:Noteshow/core/di.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import '../../domain/home_page.dart/home_page_impl.dart';

@singleton
class NetworkController {
  final Connectivity _connectivity = Connectivity();
  @PostConstruct(preResolve: true)
  Future<void> onInit() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    print(">>>>>>>>$connectivityResult");
    if (connectivityResult.any((element) =>
        element == ConnectivityResult.wifi ||
        element == ConnectivityResult.mobile)) {
      final HomePageImpl homePageImpl = di.get();
      homePageImpl.load();
    }
  }
}
