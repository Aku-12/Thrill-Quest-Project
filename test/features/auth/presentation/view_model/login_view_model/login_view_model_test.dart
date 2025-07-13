import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockAuthLoginUsecase extends Mock implements AuthLoginUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

class MockSnackbar extends Mock {
  void call({
    required BuildContext context,
    required String message,
    Color? color,
  });
}

void main() {
  late MockAuthLoginUsecase mockAuthLoginUsecase;
  late LoginViewModel loginViewModel;
  late BuildContext fakeContext;
  late MockSnackbar mockSnackbar;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(LoginParams(email: '', password: '')); // ✅ Fix here
  });

  setUp(() {
    mockAuthLoginUsecase = MockAuthLoginUsecase();
    fakeContext = FakeBuildContext();
    mockSnackbar = MockSnackbar();

    loginViewModel = LoginViewModel(
      mockAuthLoginUsecase,
      showSnackbar: mockSnackbar.call,
    );
  });

  const email = 'test@example.com';
  const password = 'password123';
  const userId = 'user-123';

  blocTest<LoginViewModel, LoginState>(
    'emits [submitting, success] and calls green snackbar on successful login',
    build: () {
      when(
        () => mockAuthLoginUsecase(any()),
      ).thenAnswer((_) async => const Right(userId));
      return loginViewModel;
    },
    act: (bloc) => bloc.add(LoginSubmitted(fakeContext, email, password)),
    wait: const Duration(seconds: 3), // Accounts for Future.delayed
    expect: () => [
      LoginState(
        formStatus: FormStatus.submitting,
        message: 'Submission Under Process',
      ),
      LoginState(
        formStatus: FormStatus.success,
        message: 'Login Successful!',
      ),
    ],
    verify: (_) {
      verify(
        () => mockAuthLoginUsecase(LoginParams(email: email, password: password)),
      ).called(1);
      verify(
        () => mockSnackbar.call(
          context: fakeContext,
          message: 'Login Successful!',
          color: Colors.green,
        ),
      ).called(1);
    },
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [submitting, failure] and calls red snackbar on failed login',
    build: () {
      when(
        () => mockAuthLoginUsecase(any()),
      ).thenAnswer((_) async => Left(ApiFailure(message: "Login failed")));
      return loginViewModel;
    },
    act: (bloc) => bloc.add(LoginSubmitted(fakeContext, email, password)),
    wait: const Duration(seconds: 3),
    expect: () => [
      LoginState(
        formStatus: FormStatus.submitting,
        message: 'Submission Under Process',
      ),
      LoginState(
        formStatus: FormStatus.failure,
        message: 'Login Failed!',
      ),
    ],
    verify: (_) {
      verify(
        () => mockAuthLoginUsecase(LoginParams(email: email, password: password)),
      ).called(1);
      verify(
        () => mockSnackbar.call(
          context: fakeContext,
          message: 'Login failed!',
          color: Colors.red,
        ),
      ).called(1);
    },
  );
}
