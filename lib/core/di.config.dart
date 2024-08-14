// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../domain/event_calendar.dart/event_calendar_impl.dart' as _i3;
import '../domain/home_page.dart/home_page_impl.dart' as _i4;
import '../domain/services/isar_services.dart' as _i6;
import '../view/pages/home/index.dart' as _i5;
import 'network/network_controller.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.EventCalendarImpl>(() => _i3.EventCalendarImpl());
    gh.singleton<_i4.HomePageImpl>(
        () => _i4.HomePageImpl(homeBlocImpl: gh<_i5.HomeBloc>()));
    gh.singleton<_i6.IsarServices>(() => _i6.IsarServices());
    await gh.singletonAsync<_i7.NetworkController>(
      () {
        final i = _i7.NetworkController();
        return i.onInit().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}
