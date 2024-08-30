import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnLoginState extends LoginState {

  UnLoginState();

  @override
  String toString() => 'UnLoginState';
}

/// Initialized
class InLoginState extends LoginState {
  InLoginState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InLoginState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorLoginState extends LoginState {
  ErrorLoginState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorLoginState';

  @override
  List<Object> get props => [errorMessage];
}
