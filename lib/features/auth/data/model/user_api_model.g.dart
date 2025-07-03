// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      fName: json['fName'] as String,
      lName: json['lName'] as String,
      email: json['email'] as String,
      phoneNo: json['phoneNo'] as String,
      password: json['password'] as String,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fName': instance.fName,
      'lName': instance.lName,
      'email': instance.email,
      'phoneNo': instance.phoneNo,
      'password': instance.password,
      'role': instance.role,
    };
