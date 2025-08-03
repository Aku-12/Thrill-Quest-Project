import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

// Enum to represent the status of the state
enum ProfileStatus { initial, loading, success, failure, saved }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final File? imageFile; // For the newly picked image
  final Failure? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.imageFile,
    this.error,
  });

  // copyWith method to easily create a new state from the existing one
  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    File? imageFile,
    Failure? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      imageFile: imageFile ?? this.imageFile,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, imageFile, error];
}