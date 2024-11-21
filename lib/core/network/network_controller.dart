import 'package:Noteshow/index.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@singleton
class NetworkController {
  final Connectivity _connectivity = Connectivity();
  @PostConstruct(preResolve: true)
  Future<void> onInit() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.any((element) =>
        element == ConnectivityResult.wifi ||
        element == ConnectivityResult.mobile)) {
      final HomePageImpl homePageImpl = di.get();
      homePageImpl.load();
    }
  }
}
