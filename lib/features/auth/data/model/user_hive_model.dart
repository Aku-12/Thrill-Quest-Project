import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thrill_quest/app/constant/hive/hive_table_constant.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fName;

  @HiveField(2)
  final String? lName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? phoneNo;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? role;

  @HiveField(7)
  final String? profileImage;

  @HiveField(8)
  final List<String>? favorites;

  UserHiveModel({
    String? userId,
    required this.fName,
    this.lName,
    required this.email,
    this.phoneNo,
    this.password,
    this.role,
    this.profileImage,
    this.favorites,
  }) : userId = userId ?? const Uuid().v4();

  // From Entity to Hive Model
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.id,
      fName: entity.fName,
      lName: entity.lName,
      email: entity.email,
      phoneNo: entity.phoneNo,
      password: entity.password,
      role: entity.role,
      profileImage: entity.profileImage,
      favorites: entity.favorites,
    );
  }

  // From Hive Model to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      fName: fName,
      lName: lName,
      email: email,
      phoneNo: phoneNo,
      password: password,
      role: role,
      profileImage: profileImage,
      favorites: favorites,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fName,
        lName,
        email,
        phoneNo,
        password,
        role,
        profileImage,
        favorites,
      ];
}
