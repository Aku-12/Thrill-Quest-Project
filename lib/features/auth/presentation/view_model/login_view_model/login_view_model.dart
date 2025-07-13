import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/core/common/snackbar/my_snack_bar.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final AuthLoginUsecase _authLoginUsecase;
  final void Function({
    required BuildContext context,
    required String message,
    Color? color,
  })
  _showSnackbar;

  LoginViewModel(
    this._authLoginUsecase, {
    void Function({
      required BuildContext context,
      required String message,
      Color? color,
    })?
    showSnackbar,
  }) : _showSnackbar = showSnackbar ?? showMySnackBar,
       super(LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final email = event.email;
    final password = event.password;

    emit(
      state.copyWith(
        formStatus: FormStatus.submitting,
        message: 'Submission Under Process',
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    final result = await _authLoginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (l) => {
        emit(
          state.copyWith(
            message: 'Login Failed!',
            formStatus: FormStatus.failure,
          ),
        ),
        _showSnackbar(
          context: event.context,
          message: 'Login failed!',
          color: Colors.red,
        ),
      },
      (r) => {
        emit(
          state.copyWith(
            message: 'Login Successful!',
            formStatus: FormStatus.success,
          ),
        ),
        _showSnackbar(
          context: event.context,
          message: 'Login Successful!',
          color: Colors.green,
        ),
      },
    );
  }
}
