import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view/login_view.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
 
  final AuthRegisterUsecase _authRegisterUsecase;
 
  SignupViewModel(
    this._authRegisterUsecase
  ) : super(const SignupState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterFullNameChanged>(_onFullNameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<FormReset>(_onResetForm);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
    on<OnSubmittedEvent>(_onSubmitted);
  }
 
  void _onEmailChanged(RegisterEmailChanged event, Emitter<SignupState> emit) {
    final email = event.email;
 
    emit(state.copyWith(email: email));
  }
 
  void _onFullNameChanged(RegisterFullNameChanged event, Emitter<SignupState> emit) {
    final fullName = event.fullName;
 
    emit(state.copyWith(fullName: fullName));
  }
 
  void _onPasswordChanged(RegisterPasswordChanged event, Emitter<SignupState> emit) {
    final password = event.password;
 
    emit(state.copyWith(password: password));
  }
 
  Future<void> _onSubmitted(OnSubmittedEvent event, Emitter<SignupState> emit) async {
    emit(state.copyWith(emailFormStatus: EmailFormStatus.submitting));
 
    final data = await _authRegisterUsecase(
      AuthRegisterParams(
        email: event.email,
        fullName: event.fullName,
        password: event.password
      )
    );
 
    Future.delayed(Duration(seconds: 2));
 
    data.fold(
      (l) {
        emit(state.copyWith(emailFormStatus: EmailFormStatus.failure, message: 'Registration Failed!'));
      },
 
      (r) {
        emit(state.copyWith(emailFormStatus: EmailFormStatus.success, message: 'Registration Successful!'));
      }
    );
  }
 
  void _onResetForm(FormReset event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(emailFormStatus: EmailFormStatus.initial, message: null),
    );
  }

  void _onNavigateToLogin(NavigateToLoginEvent event, Emitter<SignupState> emit) {
    if (event.context.mounted) {
      Navigator.push(event.context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}