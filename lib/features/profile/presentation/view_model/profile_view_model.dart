// lib/features/profile/presentation/view_model/profile_view_model.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:thrill_quest/features/profile/domain/use_case/update_user_profile_usecase.dart';
// Correct import for the updated use case
import 'package:thrill_quest/features/profile/presentation/view_model/profile_event.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_state.dart';


class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUsecase _getUserProfileUsecase;
  // Use the updated UpdateProfileUsecase type
  final UpdateProfileUsecase _updateUserProfileUsecase;
  final ImagePicker _imagePicker;

  ProfileViewModel({
    required GetUserProfileUsecase getUserProfileUsecase,
    required UpdateProfileUsecase updateUserProfileUsecase,
  })  : _getUserProfileUsecase = getUserProfileUsecase,
        _updateUserProfileUsecase = updateUserProfileUsecase,
        _imagePicker = ImagePicker(),
        super(const ProfileState()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<PickProfileImageEvent>(_onPickProfileImage);
    on<SaveChangesEvent>(_onSaveChanges);
  }

  /// Fetches user profile from backend and updates state
  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getUserProfileUsecase();
    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.failure, error: failure)),
      (user) => emit(state.copyWith(
        status: ProfileStatus.success,
        user: user,
        imageFile: null, // Clear any temporary image on re-fetch
      )),
    );
  }

  /// Picks profile image using gallery and stores it locally in state
  Future<void> _onPickProfileImage(
    PickProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(imageFile: File(pickedFile.path)));
    }
  }

  /// Saves user profile changes including optional image file
  Future<void> _onSaveChanges(
    SaveChangesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        error: const ApiFailure(message: 'User not loaded'),
      ));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.loading));

    // Create a new UserEntity with updated fields.
    // The profileImage field in UserEntity will hold the URL string
    // from the backend after a successful update, or the old one if no new image.
    // For sending to the API, we'll use the separate imageFilePath.
    final updatedUser = state.user!.copyWith(
      fName: event.name.trim().split(' ').first,
      lName: event.name.trim().split(' ').length > 1
          ? event.name.trim().split(' ').sublist(1).join(' ')
          : '',
      email: event.email,
      phoneNo: event.phone,
      // The profileImage in UserEntity should eventually reflect the *backend's* stored image path/URL.
      // For the update request, we just need the local file path if a new one was picked.
      // So, we don't necessarily need to put the local File.path into updatedUser.profileImage
      // before sending the request, as the backend will return the *new* URL.
      // However, if your UserEntity's profileImage field is temporarily holding the local path
      // before the request, that's okay, but it should be updated with the server's URL after success.
      // Let's ensure the backend returns the full user object including the updated image URL.
    );

    // Create the UpdateProfileParams object with both user data and image file path
    final params = UpdateProfileParams(
      updatedUser: updatedUser,
      imageFilePath: state.imageFile?.path, // Pass the path of the picked image file
    );

    final result = await _updateUserProfileUsecase(params);
    debugPrint("Update Profile Usecase Result: $result"); // Debugging the result

    await result.fold(
      (failure) async {
        emit(state.copyWith(status: ProfileStatus.failure, error: failure));
      },
      (user) async {
        emit(state.copyWith(
          status: ProfileStatus.saved,
          user: user, // Update the user in the state with the potentially new image URL from the server
          imageFile: null, // Clear the locally picked image file after successful upload
        ));
        // Re-fetch fresh profile from server to ensure consistency,
        // especially important if the backend sends a new image URL.
        add(FetchUserProfileEvent());
      },
    );
  }
}