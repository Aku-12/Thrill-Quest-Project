import 'package:equatable/equatable.dart';

enum FormStatus { initial, submitting, success, failure }

class SignupState extends Equatable {
  final String fName;
  final String lName;
  final String email;
  final String phoneNo;
  final String password;
  final FormStatus formStatus;

  const SignupState({
    this.fName = '',
    this.lName = '',
    this.email = '',
    this.phoneNo = '',
    this.password = '',
    this.formStatus = FormStatus.initial,
  });

  SignupState copyWith({
    String? fName,
    String? lName,
    String? email,
    String? phoneNo,
    String? password,
    FormStatus? formStatus,
    String? message,
  }) {
    return SignupState(
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
    fName,
    lName,
    email,
    phoneNo,
    password,
    formStatus,
  ];
}
