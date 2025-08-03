import 'dart:io';
import 'package:equatable/equatable.dart';

// Abstract base class for all profile-related events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger fetching user data from the repository
class FetchUserProfileEvent extends ProfileEvent {}

// Event triggered when the user picks a new profile image
class PickProfileImageEvent extends ProfileEvent {}

// Event to save the updated profile information
class SaveChangesEvent extends ProfileEvent {
  final String name;
  final String email;
  final String phone;
  final File? profileImage;

  const SaveChangesEvent({
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  @override
  List<Object?> get props => [name, email, phone, profileImage];
}