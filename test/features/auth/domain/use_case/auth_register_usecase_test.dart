import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late AuthRegisterUsecase usecase;

  setUp(() {
    repository = AuthRepoMock();
    usecase = AuthRegisterUsecase(authRepository: repository);
  });

  test(
    "should call [IAuthRepository.createAccount] with correct user entity",
    () async {
      // Arrange
      const registerParams = AuthRegisterParams(
        email: 'test@example.com',
        fName: 'John',
        lName: 'Doe',
        phoneNo: '9800000000',
        password: 'securePassword123',
      );

      final expectedUser = UserEntity(
        email: registerParams.email,
        fName: registerParams.fName,
        lName: registerParams.lName,
        phoneNo: registerParams.phoneNo,
        password: registerParams.password,
      );

      when(() => repository.createAccount(expectedUser))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(registerParams);

      // Assert
      expect(result, const Right(null));
      verify(() => repository.createAccount(expectedUser)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  tearDown(() {
    reset(repository);
  });
}
