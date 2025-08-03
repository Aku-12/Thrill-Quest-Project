// test/features/auth/domain/usecase/auth_login_usecase_test.dart

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';

// Mocks
class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthService extends Mock implements AuthService {}

// Fake for UserEntity to avoid errors in mocks
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late AuthLoginUsecase usecase;
  late MockAuthRepository mockAuthRepository;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthService = MockAuthService();
    usecase = AuthLoginUsecase(
      authRepository: mockAuthRepository,
      authService: mockAuthService,
    );

    // Register fallback for UserEntity parameters in mocks
    registerFallbackValue(FakeUserEntity());
  });

  group('LoginParams', () {
    test('should create with given email and password', () {
      const params = LoginParams(email: 'a@b.com', password: '1234');
      expect(params.email, 'a@b.com');
      expect(params.password, '1234');
    });

    test('should create initial LoginParams with empty fields', () {
      const initial = LoginParams.initial();
      expect(initial.email, '');
      expect(initial.password, '');
    });

    test('should compare equal LoginParams', () {
      const p1 = LoginParams(email: 'x', password: 'y');
      const p2 = LoginParams(email: 'x', password: 'y');
      expect(p1, p2);
    });

    test('should not equal different LoginParams', () {
      const p1 = LoginParams(email: 'x', password: 'y');
      const p2 = LoginParams(email: 'x', password: 'z');
      expect(p1 == p2, false);
    });
  });

  group('AuthLoginUsecase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testParams = LoginParams(email: testEmail, password: testPassword);

    final fakeUser = UserEntity(
      id: 'user123',
      email: testEmail,
      fName: 'testname',
      // other fields if any
    );

    const fakeToken = 'token_abc123';

    test('should create usecase with provided repository and service', () {
      final instance = AuthLoginUsecase(
          authRepository: mockAuthRepository, authService: mockAuthService);
      expect(instance, isA<AuthLoginUsecase>());
    });

    test('should call loginToAccount with correct email and password', () async {
      when(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .thenAnswer((_) async => Right((
                token: fakeToken,
                user: fakeUser,
              )));

      when(() => mockAuthService.signIn(any(), any()))
          .thenAnswer((_) async => Future.value());

      await usecase.call(testParams);

      verify(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .called(1);
    });

    test('should call AuthService.signIn with correct user and token on success', () async {
      when(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .thenAnswer((_) async => Right((
                token: fakeToken,
                user: fakeUser,
              )));

      when(() => mockAuthService.signIn(fakeUser, fakeToken))
          .thenAnswer((_) async => Future.value());

      final result = await usecase.call(testParams);

      verify(() => mockAuthService.signIn(fakeUser, fakeToken)).called(1);
      expect(result, Right(fakeToken));
    });

    test('should return Left Failure and not call signIn on failure', () async {
      final failure = ApiFailure(message: 'Invalid credentials');

      when(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase.call(testParams);

      verifyNever(() => mockAuthService.signIn(any(), any()));
      expect(result, Left(failure));
    });

    test('should await signIn before returning token', () async {
      final completer = Completer<void>();

      when(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .thenAnswer((_) async => Right((
                token: fakeToken,
                user: fakeUser,
              )));

      when(() => mockAuthService.signIn(fakeUser, fakeToken))
          .thenAnswer((_) => completer.future);

      final futureResult = usecase.call(testParams);

      // SignIn not completed yet, so futureResult shouldn't complete.
      expect(futureResult, isA<Future<Either<Failure, String>>>());

      completer.complete();

      final result = await futureResult;

      verify(() => mockAuthService.signIn(fakeUser, fakeToken)).called(1);
      expect(result, Right(fakeToken));
    });

    test('should propagate Failure if loginToAccount returns Left', () async {
      final failure = ServerFailure(message: 'Server down');

      when(() => mockAuthRepository.loginToAccount(testEmail, testPassword))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase.call(testParams);

      expect(result.isLeft(), true);
      result.fold(
        (fail) => expect(fail, failure),
        (_) => fail('Expected failure'),
      );
    });
  });
}
