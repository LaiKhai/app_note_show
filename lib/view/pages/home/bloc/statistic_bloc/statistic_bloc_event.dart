import 'dart:async';
import 'dart:developer' as developer;

import 'package:Noteshow/view/pages/home/bloc/statistic_bloc/index.dart';
import 'package:intl/intl.dart';

import '../../../../../index.dart';

@immutable
abstract class StatisticBlocEvent {
  Stream<StatisticBlocState> applyAsync(
      {StatisticBlocState currentState, StatisticBlocBloc bloc});
}

class UnStatisticBlocEvent extends StatisticBlocEvent {
  @override
  Stream<StatisticBlocState> applyAsync(
      {StatisticBlocState? currentState, StatisticBlocBloc? bloc}) async* {
    yield const UnStatisticBlocState();
  }
}

class CountTotalShowEvent extends StatisticBlocEvent {
  final IsarServices isarServices = di.get();
  @override
  Stream<StatisticBlocState> applyAsync(
      {StatisticBlocState? currentState, StatisticBlocBloc? bloc}) async* {
    try {
      final lstfilterCalendar = await isarServices.countTotal();
      List<int> numericPrices = lstfilterCalendar.map((price) {
        return int.parse(price.price!.replaceAll(RegExp(r'[^\d]'), ''));
      }).toList();
      int total = numericPrices.fold(0, (sum, price) => sum + price);
      String formattedTotal =
          "${NumberFormat("#,###", "vi_VN").format(total)}đ";
      yield CountTotalShowState(
          lstfilterCalendar.length.toString(), formattedTotal);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'ErrorStatisticBlocState', error: _, stackTrace: stackTrace);
      yield ErrorStatisticBlocState(_.toString());
    }
  }
}
