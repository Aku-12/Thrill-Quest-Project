import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/core/common/snackbar/my_snack_bar.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';
// import 'package:thrill_quest/features/auth/presentation/view/login_view.dart';
// import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final AuthRegisterUsecase _authRegisterUsecase;
  final void Function({
    required BuildContext context,
    required String message,
    Color? color,
  })
  _showSnackbar;

  SignupViewModel(
    this._authRegisterUsecase, {
    void Function({
      required BuildContext context,
      required String message,
      Color? color,
    })?
    showSnackbar,
  }) : _showSnackbar = showSnackbar ?? showMySnackBar,
       super(const SignupState()) {
    on<OnSubmittedEvent>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    OnSubmittedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormStatus.submitting));

    final data = await _authRegisterUsecase(
      AuthRegisterParams(
        fName: event.fName,
        lName: event.lName,
        email: event.email,
        phoneNo: event.phoneNo,
        password: event.password,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    data.fold(
      (l) {
        emit(state.copyWith(formStatus: FormStatus.failure));
        _showSnackbar(
          context: event.context,
          message: 'Account creation failed!',
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(formStatus: FormStatus.success));
        _showSnackbar(
          context: event.context,
          message: 'Account successfully created!',
          color: Colors.green,
        );
      },
    );
  }
}
