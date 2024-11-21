import 'package:Noteshow/view/pages/home/index.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../view/pages/home/bloc/statistic_bloc/index.dart';
import 'network/api_service.dart';
import 'network/dio_factory.dart';
import 'network/nnetword_infor.dart';

import 'di.config.dart';

final di = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => di.init();

Future<void> initAppModule() async {
  // // SharedPreferences instance
  // final sharedPreferences = await SharedPreferences.getInstance();
  // instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // AppPreferences instance
  // final appPreferences = AppPreferences(instance());
  // instance
  //     .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  //NetworkInfo instance
  di.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  //DioFactory instance
  di.registerLazySingleton<DioFactory>(() => DioFactory());

  final dio = await di<DioFactory>().getDio();

  if (kDebugMode) {
    debugPrint("${GetIt.I.isRegistered<NetworkInfo>()} " "NetworkInfo");
    debugPrint("${GetIt.I.isRegistered<DioFactory>()} " "DioFactory");
  }

  //AppServiceClient instance
  di.registerLazySingleton(() => ApiService(dio));
  di.registerLazySingleton(() => HomeBloc(const UnHomeState()));
  di.registerLazySingleton(
      () => StatisticBlocBloc(const UnStatisticBlocState()));
}
