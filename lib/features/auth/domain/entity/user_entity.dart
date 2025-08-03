import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String email;
  final String fName;
  final String? lName;
  final String? phoneNo;
  final String? password;
  final String? role;
  final String? profileImage;
  final List<String>? favorites;

  const UserEntity({
    this.id,
    required this.email,
    required this.fName,
    this.lName,
    this.phoneNo,
    this.password,
    this.role = 'customer',
    this.profileImage,
    this.favorites,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? fName,
    String? lName,
    String? phoneNo,
    String? password,
    String? role,
    String? profileImage,
    List<String>? favorites,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fName,
    lName,
    phoneNo,
    password,
    role,
    profileImage,
    favorites,
  ];

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? json['_id'] as String?,
      email: json['email'] as String,
      fName: json['fName'] as String,
      lName: json['lName'] as String?,
      phoneNo: json['phoneNo'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String? ?? 'customer',
      profileImage: json['profileImage'] as String?,
      favorites:
          (json['favorites'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fName': fName,
      'lName': lName,
      'phoneNo': phoneNo,
      'password': password,
      'role': role,
      'profileImage': profileImage,
      'favorites': favorites,
    };
  }
}
