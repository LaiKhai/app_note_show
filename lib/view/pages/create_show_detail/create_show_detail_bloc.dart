import 'dart:developer' as developer;

import 'package:Noteshow/view/pages/create_show_detail/index.dart';

class CreateShowDetailBloc
    extends Bloc<CreateShowDetailEvent, CreateShowDetailState> {
  CreateShowDetailBloc(super.initialState) {
    on<CreateShowDetailEvent>((event, emit) {
      return emit.forEach<CreateShowDetailState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error',
              name: 'CreateShowDetailBloc',
              error: error,
              stackTrace: stackTrace);
          return ErrorCreateShowDetailState(error.toString());
        },
      );
    });
  }
}
