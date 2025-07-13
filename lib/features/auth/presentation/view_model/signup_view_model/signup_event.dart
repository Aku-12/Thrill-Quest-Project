import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

// class NavigateToLoginEvent extends SignupEvent {
//   final BuildContext context;

//   // const NavigateToLoginEvent({required this.context});
// }

class OnSubmittedEvent extends SignupEvent {
  final BuildContext context;
  final String fName;
  final String lName;
  final String email;
  final String phoneNo;
  final String password;

  const OnSubmittedEvent(
    this.context,
    this.fName,
    this.lName,
    this.email,
    this.phoneNo,
    this.password,
  );

  @override
  List<Object?> get props => [context, fName, lName, email, phoneNo, password];
}

class FormReset extends SignupEvent {}
