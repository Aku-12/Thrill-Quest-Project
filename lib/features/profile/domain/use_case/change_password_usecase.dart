import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordParams extends Equatable {
  final String userId;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, oldPassword, newPassword];
}

class ChangePasswordUsecase implements UseCaseWithParams<void, ChangePasswordParams> {
  final IAuthRepository _authRepository;

  ChangePasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await _authRepository.changePassword(
      userId: params.userId,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}