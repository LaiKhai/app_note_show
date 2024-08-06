import 'package:flutter/foundation.dart';
import 'package:flutter_base_project/core/network/api_service.dart';
import 'package:flutter_base_project/core/network/nnetword_infor.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network/dio_factory.dart';

final instance = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> initAppModule() async {
  // // SharedPreferences instance
  // final sharedPreferences = await SharedPreferences.getInstance();
  // instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // AppPreferences instance
  // final appPreferences = AppPreferences(instance());
  // instance
  //     .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  //NetworkInfo instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  //DioFactory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory());

  final dio = await instance<DioFactory>().getDio();

  if (kDebugMode) {
    print("${GetIt.I.isRegistered<NetworkInfo>()} " "NetworkInfo");
    print("${GetIt.I.isRegistered<DioFactory>()} " "DioFactory");
  }

  //AppServiceClient instance
  instance.registerLazySingleton(() => ApiService(dio));
}
