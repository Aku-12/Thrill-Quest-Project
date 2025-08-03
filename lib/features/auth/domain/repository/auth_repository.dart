import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> createAccount(UserEntity user);
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity updatedUser,
    String? imageFilePath,
  );

  Future<Either<Failure, UserEntity>> getCachedUser();
  Future<Either<Failure, void>> saveUserLocally(UserEntity user);
  Future<Either<Failure, void>> saveTokenLocally(String token);
  Future<Either<Failure, String>> getTokenLocally();
  Future<Either<Failure, void>> logoutUser();
}
