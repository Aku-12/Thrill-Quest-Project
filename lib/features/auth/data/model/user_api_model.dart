import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;

  final String fName;
  final String? lName;
  final String email;
  final String? phoneNo;
  final String? password;
  final String? role;
  final String? profileImage;
  final List<String>? favorites;

  const UserApiModel({
    this.userId,
    required this.fName,
    this.lName,
    required this.email,
    this.phoneNo,
    this.password,
    this.role,
    this.profileImage,
    this.favorites,
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
      profileImage: profileImage,
      favorites: favorites,
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    return UserApiModel(
      userId: userEntity.id,
      fName: userEntity.fName,
      lName: userEntity.lName,
      phoneNo: userEntity.phoneNo,
      email: userEntity.email,
      password: userEntity.password,
      role: userEntity.role,
      profileImage: userEntity.profileImage,
      favorites: userEntity.favorites,
    );
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
    profileImage,
    favorites,
  ];
}
