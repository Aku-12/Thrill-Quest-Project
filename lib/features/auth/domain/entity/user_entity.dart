import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String email;
  final String fName;
  final String lName;
  final String phoneNo;
  final String password;
  final String? role;

  const UserEntity({
    this.id,
    required this.email,
    required this.fName,
    required this.lName,
    required this.phoneNo,
    required this.password,
    this.role = 'customer',
  });

  @override
  List<Object?> get props => [id, email, fName, lName, phoneNo, password, role];
}
