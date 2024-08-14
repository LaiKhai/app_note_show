import 'package:equatable/equatable.dart';

abstract class CreateShowDetailState extends Equatable {
  const CreateShowDetailState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnCreateShowDetailState extends CreateShowDetailState {
  const UnCreateShowDetailState();

  @override
  String toString() => 'UnCreateShowDetailState';
}

/// Initialized
class InCreateShowDetailState extends CreateShowDetailState {
  const InCreateShowDetailState(this.hello);

  final String hello;

  @override
  String toString() => 'InCreateShowDetailState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorCreateShowDetailState extends CreateShowDetailState {
  const ErrorCreateShowDetailState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorCreateShowDetailState';

  @override
  List<Object> get props => [errorMessage];
}
