import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String email;
  final String fullName;
  final String password;
 
  const UserEntity({
    this.id,
    required this.email,
    required this.fullName,
    required this.password,
  });
 
  @override
  List<Object?> get props => [id, email, fullName, password];
}