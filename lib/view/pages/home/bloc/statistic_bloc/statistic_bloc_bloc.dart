import 'dart:developer' as developer;

import 'package:Noteshow/view/pages/home/bloc/statistic_bloc/index.dart';

import '../../../../../index.dart';

class StatisticBlocBloc extends Bloc<StatisticBlocEvent, StatisticBlocState> {
  StatisticBlocBloc(super.initialState) {
    on<StatisticBlocEvent>((event, emit) {
      return emit.forEach<StatisticBlocState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'StatisticBlocBloc', error: error, stackTrace: stackTrace);
          return ErrorStatisticBlocState(error.toString());
        },
      );
    });
  }
}
