// lib/features/auth/data/repository/auth_remote_repository.dart
import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/data/data_source/remote_local_source/auth_remote_datasource.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRemoteRepository({required AuthRemoteDatasource authRemoteDatasource})
    : _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    try {
      await _authRemoteDatasource.createAccount(user);
      return const Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      final result = await _authRemoteDatasource.loginToAccount(
        email,
        password,
      );
      return Right(result);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _authRemoteDatasource.changePassword(
        userId: userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await _authRemoteDatasource.getUserProfile();
      return Right(user);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity updatedUser,
    String? imageFilePath,
  ) async {
    try {
      final user = await _authRemoteDatasource.updateProfile(
        updatedUser,
        imageFilePath,
      );
      return Right(user);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getTokenLocally() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logoutUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> saveTokenLocally(String token) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> saveUserLocally(UserEntity user) {
    throw UnimplementedError();
  }
}
