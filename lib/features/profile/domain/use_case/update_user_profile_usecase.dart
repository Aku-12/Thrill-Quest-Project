import 'package:dartz/dartz.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileParams {
  final UserEntity updatedUser;
  final String? imageFilePath;

  const UpdateProfileParams({
    required this.updatedUser,
    this.imageFilePath,
  });
}

class UpdateProfileUsecase implements UseCaseWithParams<UserEntity, UpdateProfileParams> {
  final IAuthRepository _authRepository;

  UpdateProfileUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await _authRepository.updateProfile(
      params.updatedUser,
      params.imageFilePath,
    );
  }
}