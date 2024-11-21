import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnProfileState extends ProfileState {
  const UnProfileState();

  @override
  String toString() => 'UnProfileState';
}

/// Initialized
class InProfileState extends ProfileState {
  const InProfileState(this.hello);

  final String hello;

  @override
  String toString() => 'InProfileState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorProfileState extends ProfileState {
  const ErrorProfileState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorProfileState';

  @override
  List<Object> get props => [errorMessage];
}
