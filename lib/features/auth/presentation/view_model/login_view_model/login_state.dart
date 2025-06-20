import 'package:equatable/equatable.dart';

enum FormStatus {
  initial,
  submitting,
  success,
  failure
}
 
class LoginState extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final bool obscurePassword;
  final FormStatus formStatus;
  final String? message;
 
  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.obscurePassword = true,
    this.formStatus = FormStatus.initial,
    this.message
  });
 
  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? obscurePassword,
    FormStatus? formStatus,
    String? message
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message
    );
  }
 
  @override
  List<Object?> get props => [
    email,
    password,
    rememberMe,
    obscurePassword,
    formStatus,
    message
  ];
}