import 'package:equatable/equatable.dart';

abstract class StatisticBlocState extends Equatable {
  const StatisticBlocState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnStatisticBlocState extends StatisticBlocState {
  const UnStatisticBlocState();

  @override
  String toString() => 'UnStatisticBlocState';
}

/// Initialized
class InStatisticBlocState extends StatisticBlocState {
  const InStatisticBlocState(this.hello);

  final String hello;

  @override
  String toString() => 'InStatisticBlocState $hello';

  @override
  List<Object> get props => [hello];
}

class CountTotalShowState extends StatisticBlocState {
  const CountTotalShowState(this.totalShow, this.totalAmount);

  final String totalShow;
  final String totalAmount;

  @override
  String toString() => 'CountTotalShowState $totalShow';

  @override
  List<Object> get props => [totalShow];
}

class ErrorStatisticBlocState extends StatisticBlocState {
  const ErrorStatisticBlocState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorStatisticBlocState';

  @override
  List<Object> get props => [errorMessage];
}
