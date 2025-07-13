import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class MockAuthRegisterUsecase extends Mock implements AuthRegisterUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockAuthRegisterUsecase mockAuthRegisterUsecase;
  late SignupViewModel signupViewModel;
  late BuildContext fakeContext;
  final List<String> snackbarMessages = [];

  void testSnackBar({
    required BuildContext context,
    required String message,
    Color? color,
  }) {
    snackbarMessages.add(message);
  }

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(
      AuthRegisterParams(
        email: '',
        fName: '',
        lName: '',
        phoneNo: '',
        password: '',
      ),
    );
  });

  setUp(() {
    mockAuthRegisterUsecase = MockAuthRegisterUsecase();
    fakeContext = FakeBuildContext();
    snackbarMessages.clear();

    signupViewModel = SignupViewModel(
      mockAuthRegisterUsecase,
      showSnackbar: testSnackBar,
    );
  });

  const email = 'user@example.com';
  const fName = 'John';
  const lName = 'Doe';
  const phoneNo = '1234567890';
  const password = 'password123';

  blocTest<SignupViewModel, SignupState>(
    'emits [submitting, success] and triggers green snackbar',
    build: () {
      when(() => mockAuthRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(null));
      return SignupViewModel(
        mockAuthRegisterUsecase,
        showSnackbar: testSnackBar,
      );
    },
    act: (bloc) => bloc.add(
      OnSubmittedEvent(fakeContext, fName, lName, email, phoneNo, password),
    ),
    wait: const Duration(seconds: 3),
    expect: () => [
      const SignupState(formStatus: FormStatus.submitting),
      const SignupState(formStatus: FormStatus.success),
    ],
    verify: (_) {
      verify(() => mockAuthRegisterUsecase(AuthRegisterParams(
            fName: fName,
            lName: lName,
            email: email,
            phoneNo: phoneNo,
            password: password,
          ))).called(1);

      expect(snackbarMessages, contains('Account successfully created!'));
    },
  );

  blocTest<SignupViewModel, SignupState>(
    'emits [submitting, failure] and triggers red snackbar',
    build: () {
      when(() => mockAuthRegisterUsecase(any()))
          .thenAnswer((_) async => Left(ApiFailure(message: "fail")));
      return SignupViewModel(
        mockAuthRegisterUsecase,
        showSnackbar: testSnackBar,
      );
    },
    act: (bloc) => bloc.add(
      OnSubmittedEvent(fakeContext, fName, lName, email, phoneNo, password),
    ),
    wait: const Duration(seconds: 3),
    expect: () => [
      const SignupState(formStatus: FormStatus.submitting),
      const SignupState(formStatus: FormStatus.failure),
    ],
    verify: (_) {
      verify(() => mockAuthRegisterUsecase(AuthRegisterParams(
            fName: fName,
            lName: lName,
            email: email,
            phoneNo: phoneNo,
            password: password,
          ))).called(1);

      expect(snackbarMessages, contains('Account creation failed!'));
    },
  );
}
