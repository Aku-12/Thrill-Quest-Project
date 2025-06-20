import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thrill_quest/app/constant/hive/hive_table_constant.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
 
  @HiveField(1)
  final String email;
 
  @HiveField(2)
  final String fullName;
 
  @HiveField(3)
  final String password;
 
  AuthHiveModel({
    String? userId,
    required this.email,
    required this.fullName,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();
 
  // From Entity to Hive Model
  factory AuthHiveModel.fromEntity(UserEntity entity) {
    return AuthHiveModel(
      userId: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      password: entity.password,
    );
  }
 
  // From Hive Model to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      email: email,
      fullName: fullName,
      password: password,
    );
  }
 
  @override
  List<Object?> get props => [
    userId,
    email,
    fullName,
    password,
  ];
}
 