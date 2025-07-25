import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class AuthRegisterParams extends Equatable {
  final String email;
  final String fName;
  final String lName;
  final String phoneNo;
  final String password;
 
  const AuthRegisterParams({
    required this.email,
    required this.fName,    
    required this.lName,    
    required this.phoneNo,    
    required this.password,
  });
 
  const AuthRegisterParams.initial({
    required this.email,
    required this.fName,
    required this.lName,
    required this.phoneNo,
    required this.password,
  });
 
  @override
  List<Object?> get props => [email, fName,lName, phoneNo, password];
}
 
class AuthRegisterUsecase implements UseCaseWithParams<void, AuthRegisterParams>{
 
  final IAuthRepository _authRepository;
 
  AuthRegisterUsecase({ required IAuthRepository authRepository}) : _authRepository = authRepository;
 
  @override
  Future<Either<Failure, void>> call(AuthRegisterParams params) {
    final userEntity = UserEntity(
      email: params.email,
      fName: params.fName,
      lName: params.lName,
      phoneNo: params.phoneNo,
      password: params.password,
    );
 
    return _authRepository.createAccount(userEntity);
  }
}
 
