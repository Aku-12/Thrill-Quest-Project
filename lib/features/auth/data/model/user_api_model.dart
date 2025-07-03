import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fName;
  final String lName;
  final String email;
  final String phoneNo;
  final String password;
  final String? role;

  const UserApiModel({
    this.userId,
    required this.fName,
    required this.lName,
    required this.email,
    required this.phoneNo,
    required this.password,
    this.role,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      fName: fName,
      lName: lName,
      email: email,
      phoneNo: phoneNo,
      password: password,
      role: role,
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    final user = UserApiModel(
      fName: userEntity.fName,
      lName: userEntity.lName,
      phoneNo: userEntity.phoneNo,
      email: userEntity.email,
      password: userEntity.password,
      role: userEntity.role,
    );

    return user;
  }

  @override
  List<Object?> get props => [
    userId,
    fName,
    lName,
    phoneNo,
    email,
    password,
    role,
  ];
}
