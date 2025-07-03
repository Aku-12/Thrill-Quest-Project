import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  const LoginSubmitted(this.context, this.email, this.password);

  @override
  List<Object?> get props => [context, email, password];
}

class NavigateToDashboardEvent extends LoginEvent {
  final BuildContext context;
  const NavigateToDashboardEvent({required this.context});
}
