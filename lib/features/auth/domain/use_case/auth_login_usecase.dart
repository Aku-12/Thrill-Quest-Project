// lib/features/auth/domain/usecase/auth_login_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  const LoginParams.initial() : email = '', password = '';
  @override
  List<Object?> get props => [email, password];
}

class AuthLoginUsecase implements UseCaseWithParams<String, LoginParams> {
  final IAuthRepository _authRepository;
  final AuthService _authService;

  AuthLoginUsecase({
    required IAuthRepository authRepository,
    required AuthService authService,
  })  : _authRepository = authRepository,
        _authService = authService;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await _authRepository.loginToAccount(
      params.email,
      params.password,
    );

    // CORRECTED: Use fold to get the inner value.
    // The success callback of fold is now async.
    return result.fold(
      (error) {
        // Handle the error case and return a Left immediately.
        return Left(error);
      },
      (success) async {
        // Handle the success case asynchronously.
        final user = success.user;
        final token = success.token;

        // Await the sign-in operation.
        await _authService.signIn(user, token);
        
        // Return a Right with the token.
        return Right(token);
      },
    );
  }
}