import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  HomeState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnHomeState extends HomeState {

  UnHomeState();

  @override
  String toString() => 'UnHomeState';
}

/// Initialized
class InHomeState extends HomeState {
  InHomeState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InHomeState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorHomeState extends HomeState {
  ErrorHomeState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorHomeState';

  @override
  List<Object> get props => [errorMessage];
}
