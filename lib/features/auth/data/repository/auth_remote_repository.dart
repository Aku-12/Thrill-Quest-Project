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
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      final token = await _authRemoteDatasource.loginToAccount(email, password);
      return Right(token);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
