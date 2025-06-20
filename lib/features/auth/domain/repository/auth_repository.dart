import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> createAccount(UserEntity user);
  Future<Either<Failure, String>> loginToAccount(String email, String password);
}