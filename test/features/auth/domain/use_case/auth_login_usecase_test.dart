import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_login_usecase.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late AuthLoginUsecase usecase;

  setUp(() {
    repository = AuthRepoMock();
    usecase = AuthLoginUsecase(authRepository: repository);
  });

  test(
    "should call [IAuthRepository.loginToAccount] with correct email and password ['ak@gmail.com', 'ak123456']",
    () async {
      // Arrange
      when(() => repository.loginToAccount(any(), any())).thenAnswer(
        (invocation) async {
          final email = invocation.positionalArguments[0] as String;
          final password = invocation.positionalArguments[1] as String;
          if (email == 'ak@gmail.com' && password == 'ak123456') {
            return const Right('token');
          } else {
            return const Left(
              RemoteDatabaseFailure(message: 'Invalid credentials'),
            );
          }
        },
      );

      // Act
      final result = await usecase(
        const LoginParams(email: 'ak@gmail.com', password: 'ak123456'),
      );

      // Assert
      expect(result, const Right('token'));
      verify(() => repository.loginToAccount('ak@gmail.com', 'ak123456')).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  tearDown(() {
    reset(repository);
  });
}
