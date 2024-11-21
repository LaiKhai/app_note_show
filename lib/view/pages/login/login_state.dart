import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnLoginState extends LoginState {
  const UnLoginState();

  @override
  String toString() => 'UnLoginState';
}

/// Initialized
class InLoginState extends LoginState {
  const InLoginState(this.hello);

  final String hello;

  @override
  String toString() => 'InLoginState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorLoginState extends LoginState {
  const ErrorLoginState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorLoginState';

  @override
  List<Object> get props => [errorMessage];
}
