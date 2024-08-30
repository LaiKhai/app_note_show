import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  ProfileState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnProfileState extends ProfileState {

  UnProfileState();

  @override
  String toString() => 'UnProfileState';
}

/// Initialized
class InProfileState extends ProfileState {
  InProfileState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InProfileState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorProfileState extends ProfileState {
  ErrorProfileState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorProfileState';

  @override
  List<Object> get props => [errorMessage];
}
