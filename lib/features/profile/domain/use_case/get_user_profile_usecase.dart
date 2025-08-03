import 'package:dartz/dartz.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class GetUserProfileUsecase implements UseCaseWithoutParams<UserEntity> {
  final IAuthRepository _authRepository;

  GetUserProfileUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _authRepository.getUserProfile();
  }
}
