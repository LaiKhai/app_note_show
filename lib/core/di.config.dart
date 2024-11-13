// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../domain/event_calendar.dart/event_calendar_impl.dart' as _i5;
import '../domain/home_page.dart/home_page_impl.dart' as _i6;
import '../domain/services/isar_services.dart' as _i9;
import '../view/pages/create_show_detail/create_show_detail_controller.dart'
    as _i4;
import '../view/pages/home/bloc/statistic_bloc/index.dart' as _i7;
import '../view/pages/home/index.dart' as _i8;
import '../view/widgets/bottom_sheet_wiget/bottom_sheet_widget.dart' as _i3;
import 'network/network_controller.dart' as _i10;

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
    gh.singleton<_i3.BottomSheetModal>(() => _i3.BottomSheetModal());
    gh.lazySingleton<_i4.CreateShowDetailController>(
        () => _i4.CreateShowDetailController());
    gh.singleton<_i5.EventCalendarImpl>(() => _i5.EventCalendarImpl());
    gh.lazySingleton<_i6.HomePageImpl>(() => _i6.HomePageImpl(
          statisticBlocImpl: gh<_i7.StatisticBlocBloc>(),
          homeBlocImpl: gh<_i8.HomeBloc>(),
        ));
    gh.singleton<_i9.IsarServices>(() => _i9.IsarServices());
    await gh.singletonAsync<_i10.NetworkController>(
      () {
        final i = _i10.NetworkController();
        return i.onInit().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}
