import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';
import 'package:thrill_quest/features/auth/domain/use_case/auth_register_usecase.dart';

// Mock Repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late AuthRegisterUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      UserEntity(
        email: '',
        fName: '',
        lName: '',
        phoneNo: '',
        password: '',
      ),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = AuthRegisterUsecase(authRepository: mockAuthRepository);
  });

  const tParams = AuthRegisterParams(
    email: 'test@example.com',
    fName: 'Test',
    lName: 'User',
    phoneNo: '1234567890',
    password: 'password123',
  );

  final tUserEntity = UserEntity(
    email: tParams.email,
    fName: tParams.fName,
    lName: tParams.lName,
    phoneNo: tParams.phoneNo,
    password: tParams.password,
  );

  group('AuthRegisterParams', () {
    test('initial constructor creates correct object', () {
      const params = AuthRegisterParams.initial(
        email: 'init@example.com',
        fName: 'Init',
        lName: 'User',
        phoneNo: '0000000000',
        password: 'initpass',
      );

      expect(params.email, 'init@example.com');
      expect(params.fName, 'Init');
      expect(params.lName, 'User');
      expect(params.phoneNo, '0000000000');
      expect(params.password, 'initpass');
    });

    test('equality and hashCode', () {
      const p1 = AuthRegisterParams(
        email: 'a@example.com',
        fName: 'A',
        lName: 'B',
        phoneNo: '1111',
        password: 'pass',
      );
      const p2 = AuthRegisterParams(
        email: 'a@example.com',
        fName: 'A',
        lName: 'B',
        phoneNo: '1111',
        password: 'pass',
      );
      const p3 = AuthRegisterParams(
        email: 'x@example.com',
        fName: 'X',
        lName: 'Y',
        phoneNo: '9999',
        password: 'diff',
      );

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1 == p3, isFalse);
    });
  });

  group('AuthRegisterUsecase', () {
    test('should call createAccount and return Right(void)', () async {
      when(() => mockAuthRepository.createAccount(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, equals(const Right(null)));

      final captured = verify(() => mockAuthRepository.createAccount(captureAny()))
          .captured
          .single as UserEntity;

      expect(captured.email, tUserEntity.email);
      expect(captured.fName, tUserEntity.fName);
      expect(captured.lName, tUserEntity.lName);
      expect(captured.phoneNo, tUserEntity.phoneNo);
      expect(captured.password, tUserEntity.password);

      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when repository fails', () async {
      final tFailure = ApiFailure(message: 'Failed to register user');

      when(() => mockAuthRepository.createAccount(any()))
          .thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, equals(Left(tFailure)));

      final captured = verify(() => mockAuthRepository.createAccount(captureAny()))
          .captured
          .single as UserEntity;

      expect(captured.email, tUserEntity.email);
      expect(captured.fName, tUserEntity.fName);
      expect(captured.lName, tUserEntity.lName);
      expect(captured.phoneNo, tUserEntity.phoneNo);
      expect(captured.password, tUserEntity.password);

      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
