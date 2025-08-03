import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

abstract interface class IProfileRemoteDataSource {
  Future<UserEntity> getUserProfile();

  Future<void> updateUserProfile({
    required String userId,
    required UserEntity updatedUser,
    required String? imageFilePath, // nullable if image is not updated
  });

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
}
